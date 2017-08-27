//
//  PMMyDreamBookLogic.m
//  myDreams
//
//  Created by Ivan Ushakov on 17/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookLogic.h"
#import "PMProfileApiClient.h"
#import "PMDreamerApiClient.h"
#import "PMFriendsApiClient.h"
#import "PMPostApiClient.h"
#import "PMUserProvider.h"
#import "PMImageDownloader.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseModelIdxWithIsMineContext.h"
#import "PMDreambookHeaderViewModelImpl.h"
#import "PMDreambookViewModelImpl.h"
#import "PMDreamerResponse.h"
#import "PMFriendshipRequestResponse.h"
#import "PMFeedsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMDreambookHeaderViewItemType.h"
#import "PMContainedListPhotosLogicDelegate.h"
#import "PMApplicationRouter.h"
#import "PMSubjectContext.h"
#import "PMPostMapper.h"
#import "PMPaginationBaseLogic+Protected.h"

NSString * const PMDreambookLogicErrorDomain = @"com.mydreams.MyDreamBook.logic.error";
NSString * const kPMSegueIdentifierToEditDreamProfileVC = @"ToEditDreamProfileVC";
NSString * const kPMSegueIdentifierToListPhotosVC = @"ToListPhotosVC";

@interface PMDreambookLogic ()
@property (nonatomic, strong) PMBaseModelIdxContext *context;
@property (nonatomic, strong) PMDreambookHeaderViewModelImpl *dreambookHeaderViewModel;
@property (nonatomic, strong) PMDreambookViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *changeAvatarCommand;
@property (nonatomic, strong) RACCommand *changeBackgroundCommand;
@property (nonatomic, strong) RACCommand *editCommand;
@property (nonatomic, strong) RACCommand *getMessageCommand;
@property (nonatomic, strong) RACCommand *addFriendCommand;
@property (nonatomic, strong) RACCommand *createPostCommand;
@property (nonatomic, strong) RACCommand *changeStatusCommand;
@property (nonatomic, strong) RACCommand *toSectionCommand;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *openInWebCommand;
@property (nonatomic, strong) RACCommand *toFullPostCommand;
@property (nonatomic, strong) RACChannelTerminal *statusTerminal;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) PMDreamer *foreignDreamer;
@property (nonatomic, strong) NSNumber *dreamerIdx;
@property (nonatomic, strong) RACSubject *createdPostsSubject;
@end

@implementation PMDreambookLogic
@dynamic context;

- (void)startLogic
{
    self.ignoreDataEmpty = YES;
    self.dreamerIdx = self.context.idx;
    PMDreambookHeaderViewModelImpl *headerViewModel = [[PMDreambookHeaderViewModelImpl alloc] initWithBaseUrl:self.baseUrl];
    self.viewModel = [[PMDreambookViewModelImpl alloc] init];
    
    headerViewModel.isMe = (self.context) ? [self.context.idx isEqualToNumber:self.userProvider.me.idx] : YES;
    
    @weakify(self);
    [[RACObserve(self, containerLogic) ignore:nil] subscribeNext:^(id<PMContainedListPhotosLogicDelegate> containerLogic) {
        @strongify(self);
        NSNumber *idx = (headerViewModel.isMe) ? self.userProvider.me.idx : self.dreamerIdx;
        [containerLogic setupDreamerIdx:idx isMe:headerViewModel.isMe];
    }];
    
    if (headerViewModel.isMe) {
        [self updateProfile];
    }
    else {
        [self updateForeignDreamer];
    }
    
    self.dreambookHeaderViewModel = headerViewModel;
    
    [super startLogic];

    self.toFullPostCommand = [self createToFullPostCommand];
    self.changeAvatarCommand = [self createChangeAvatarCommand];
    self.changeBackgroundCommand = [self createChangeBackgroundCommand];
    self.editCommand = [self createEditCommand];
    self.getMessageCommand = [self createGetMessageCommand];
    self.addFriendCommand = [self createAddFriendCommand];
    self.createPostCommand = [self createCreatePostCommand];
    self.changeStatusCommand = [self createChangeStatusCommand];
    self.toSectionCommand = [self createToSectionCommand];
    self.backCommand = [self createBackCommand];
    self.openInWebCommand = [self createOpenInWebCommand];

    self.statusTerminal = RACChannelTo(self, status);
    
    self.createdPostsSubject = [RACSubject subject];
    
    [self.createdPostsSubject subscribeNext:^(PMPost *post) {
        @strongify(self);
        [self appendItem:post atIndex:0];
        PMDreambookHeaderViewModelImpl *viewModel = self.dreambookHeaderViewModel;
        viewModel.postsCountInteger = viewModel.postsCountInteger + 1;
    }];
    
    RAC(self.viewModel, posts) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self.postMapper postsToViewModels:items paginationLogic:self];
        }];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    @weakify(self);
    NSNumber *idx = (self.dreambookHeaderViewModel.isMe) ? self.userProvider.me.idx : self.dreamerIdx;
    return [[[self.postApiClient getFeedsWithDreamer:idx page:page]
        doNext:^(PMFeedsResponse *response) {
            @strongify(self);
            PMDreambookHeaderViewModelImpl *viewModel = self.dreambookHeaderViewModel;
            viewModel.postsCountInteger = response.meta.totalCount;
        }]
        map:^id(PMFeedsResponse *response) {
            return RACTuplePack(response.feeds, response.meta);
        }];
}

- (RACSignal *)loadData
{
    if (self.dreambookHeaderViewModel.isMe) {
        return [self loadDataForMe];
    }
    else {
        return [self loadDataForForeignDreamer];
    }
}

- (RACCommand *)createLoadDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[self loadData]
            doError:^(NSError *error) {
                @strongify(self);
                self.isDataLoaded = NO;
            }]
            doCompleted:^{
                @strongify(self);
                self.isDataLoaded = YES;
            }];
    }];
}

#pragma mark - commands

- (RACCommand *)createChangeBackgroundCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(PMImageForm *imageForm) {
        @strongify(self);
        return [[self.profileApiClient postDreambookBackground:imageForm progress:nil] doNext:^(id input) {
            @strongify(self);
            [self.loadDataCommand execute:nil];
        }];
    }];
}

- (RACCommand *)createChangeAvatarCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(PMImageForm *imageForm) {
        @strongify(self);
        return [[self.profileApiClient postAvatar:imageForm progress:nil] doNext:^(id x) {
            @strongify(self);
            [self.loadDataCommand execute:nil];
        }];
    }];
}

- (RACCommand *)createEditCommand
{
    return [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierToEditDreamProfileVC];
}

- (RACCommand *)createBackCommand
{
    return [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseDreambookVC];
}

- (RACCommand *)createGetMessageCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
}

- (RACCommand *)createAddFriendCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if (!self.dreamerIdx) {
            NSError *error = [NSError errorWithDomain:PMDreambookLogicErrorDomain
                                                 code:PMDreambookLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"dreambook.dreambook.dreamer_not_found", nil)}];
            return [RACSignal error:error];
        }
        
        if ([self.foreignDreamer.isFriend boolValue]) {
            return [[self.friendsApiClient destroyProfileFriendRequest:self.dreamerIdx] doNext:^(id x) {
                self.foreignDreamer.isFriend = @NO;
                self.foreignDreamer.isFollower = @NO;
                [self updateDreambookHeaderViewModelWithDreamer:self.foreignDreamer viewModel:self.dreambookHeaderViewModel];
            }];
        }
        else if ([self.foreignDreamer.isFollower boolValue]) {
            return [[self.friendsApiClient destroyFriendshipRequest:self.dreamerIdx] doNext:^(id input) {
                @strongify(self);
                self.foreignDreamer.isFollower = @NO;
                [self updateDreambookHeaderViewModelWithDreamer:self.foreignDreamer viewModel:self.dreambookHeaderViewModel];
            }];
        }
        else {
            return [[self.friendsApiClient createFriendshipRequest:self.dreamerIdx] doNext:^(PMFriendshipRequestResponse *response) {
                @strongify(self);
                self.foreignDreamer.isFriend = response.friendshipRequest.receiver.isFriend;
                self.foreignDreamer.isFollower = response.friendshipRequest.receiver.isFollower;
                [self updateDreambookHeaderViewModelWithDreamer:self.foreignDreamer viewModel:self.dreambookHeaderViewModel];
            }];
        }
    }];
}

- (RACCommand *)createCreatePostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToCreatePostVC context:[PMSubjectContext contextWithSubject:self.createdPostsSubject]];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createChangeStatusCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.status = [self statusWithoutWhitespace];
        return [self.profileApiClient changeStatus:self.status];
    }];
}

- (RACCommand *)createToSectionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        PMDreambookHeaderViewItemType type = [input unsignedIntValue];
        @strongify(self);
        switch (type) {
            case PMDreambookHeaderViewItemTypeSubscribers: {
                PMBaseModelIdxContext *context;
                if (self.dreambookHeaderViewModel.isMe) {
                    context = [PMBaseModelIdxContext contextWithIdx:self.userProvider.me.idx];
                }
                else {
                    context = [PMBaseModelIdxContext contextWithIdx:self.dreamerIdx];
                }
                [self performSegueWithIdentifier:kPMSegueIdentifierToListFollowersVC context:context];
                return [RACSignal empty];
            }
            case PMDreambookHeaderViewItemTypeDreams: {
                PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:self.dreamerIdx];
                [self performSegueWithIdentifier:kPMSegueIdentifierToPersonalListDreams context:context];
                return [RACSignal empty];
            }
            case PMDreambookHeaderViewItemTypeFulfilledDreams: {
                PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:self.dreamerIdx];
                [self performSegueWithIdentifier:kPMSegueIdentifierToPersonalListFulfilledDreams context:context];
                return [RACSignal empty];
            }
            case PMDreambookHeaderViewItemTypeSubscriptions:
                [self performSegueWithIdentifier:kPMSegueIdentifierToListFolloweesVC];
                return [RACSignal empty];
            case PMDreambookHeaderViewItemTypeFriends: {
                PMBaseModelIdxWithIsMineContext *context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamerIdx isMine:self.dreambookHeaderViewModel.isMe];
                [self performSegueWithIdentifier:kPMSegueIdentifierToListFriendsVC context:context];
                return [RACSignal empty];
            }
            case PMDreambookHeaderViewItemTypePhotos: {
                PMBaseModelIdxWithIsMineContext *context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamerIdx isMine:self.dreambookHeaderViewModel.isMe];
                [self performSegueWithIdentifier:kPMSegueIdentifierToListPhotosVC context:context];
                return [RACSignal empty];
            }
            case PMDreambookHeaderViewItemTypeMarks: {
                PMBaseModelIdxWithIsMineContext *context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamerIdx isMine:self.dreambookHeaderViewModel.isMe];
                [self performSegueWithIdentifier:kPMSegueIdentifierToListCertificatesVC context:context];
                return [RACSignal empty];
            }
            default:
                return [RACSignal empty];
        }
    }];
}

- (RACCommand *)createOpenInWebCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self.router openURL:self.dreambookHeaderViewModel.dreambookUrl];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToFullPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDetailedPostVC context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

- (RACSignal *)loadDataForMe
{
    @weakify(self);
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    
    return [[RACSignal
        combineLatest:@[[self.profileApiClient getMe],
                        [super loadData],
                        containerLogicLoadData]]
        doNext:^(RACTuple *tuple) {
            @strongify(self);
            PMDreamerResponse *response = tuple.first;
            [self.userProvider setMe:response.dreamer];
        }];
}

- (RACSignal *)loadDataForForeignDreamer
{
    @weakify(self);
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    return [[RACSignal
        combineLatest:@[[self.dreamerApiClient getDreamer:self.dreamerIdx],
                        [super loadData],
                        containerLogicLoadData]]
        doNext:^(RACTuple *tuple) {
            @strongify(self);
            PMDreamerResponse *response = tuple.first;
            self.foreignDreamer = response.dreamer;
        }];
}

- (void)updateDreambookHeaderViewModelWithDreamer:(PMDreamer *)dreamer viewModel:(PMDreambookHeaderViewModelImpl *)viewModel
{
    viewModel.dreamer = dreamer;
    
    NSURL *avatarUrl = [NSURL URLWithString:dreamer.avatar.medium];
    if (avatarUrl) {
        [[self.imageDownloader imageForURL:avatarUrl] subscribeNext:^(UIImage *avatar) {
            viewModel.avatar = avatar;
        }];
    }
    NSURL *backgroundUrl = [NSURL URLWithString:dreamer.dreambookBackground.url];
    if (backgroundUrl) {
        [[self.imageDownloader imageForURL:backgroundUrl] subscribeNext:^(UIImage *background) {
            viewModel.background = background;
        }];
    }
}

- (void)updateProfile
{
    @weakify(self);
    [[RACObserve(self.userProvider, me) skip:1] subscribeNext:^(PMDreamer *dreamer) {
        @strongify(self);
        [self updateDreambookHeaderViewModelWithDreamer:dreamer viewModel:self.dreambookHeaderViewModel];
    }];
}

- (void)updateForeignDreamer
{
    @weakify(self);
    [[RACObserve(self, foreignDreamer) skip:1] subscribeNext:^(PMDreamer *dreamer) {
        @strongify(self);
        [self updateDreambookHeaderViewModelWithDreamer:dreamer viewModel:self.dreambookHeaderViewModel];
    }];
}

- (NSString *)statusWithoutWhitespace
{
    return [self.status stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end