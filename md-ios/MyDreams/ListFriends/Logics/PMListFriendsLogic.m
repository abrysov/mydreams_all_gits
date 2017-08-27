//
//  PMListFriendsLogic.m
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListFriendsLogic.h"
#import "PMFriendsApiClient.h"
#import "PMFriendsViewModelImpl.h"
#import "PMDreamerFilterForm.h"
#import "PMFriendsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "DreambookSegues.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseModelIdxWithIsMineContext.h"
#import "PMBaseLogic+Protected.h"
#import "PMFriendshipRequestsViewModelImpl.h"
#import "PMDreamerMapper.h"

NSString * const PMListFriendsLogicErrorDomain = @"com.mydreams.ListFriends.logic.error";

@interface PMListFriendsLogic ()
@property (nonatomic, strong) PMBaseModelIdxWithIsMineContext *context;
@property (strong, nonatomic) PMFriendsViewModelImpl *friendsViewModel;
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic) RACCommand *backCommand;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@property (strong, nonatomic) RACCommand *updateDateCommand;
@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListFriendsLogic
@dynamic context;

- (void)startLogic
{
    self.ignoreDataEmpty = YES;
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    [super startLogic];
    
    @weakify(self);
    [RACObserve(self, containerLogic) subscribeNext:^(PMFriendshipRequestsLogic *containerLogic) {
        @strongify(self);
        containerLogic.isMe = self.context.isMine;
    }];
    
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseListFriendsVC];
    self.toDreambookCommand = [self createToDreambookCommand];
    self.updateDateCommand = [self CreateUpdateDateCommand];
    self.searchTerminal = RACChannelTo(self, filterForm.search);
    self.cancelSignal = [RACSubject subject];
    
    PMFriendsViewModelImpl *viewModel = [[PMFriendsViewModelImpl alloc] init];
    viewModel.dreamers = @[];
    self.friendsViewModel = viewModel;

    RAC(self, friendsViewModel.dreamers) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self.dreamerMapper dreambookDreamersToViewModel:items];
        }];
    
    [[[[[[RACObserve(self, filterForm.search) skip:1]
        distinctUntilChanged]
        doNext:^(id x) {
            @strongify(self);
            [self.cancelSignal sendNext:x];
        }]
        map:^id(NSString *search) {
            @strongify(self);
            return [self.loadDataCommand execute:nil];
        }]
        switchToLatest]
        subscribeNext:^(id input) {}];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    @weakify(self);
    if (self.context.isMine) {
        return [[[self.friendsApiClient getFriends:self.filterForm page:page]
            doNext:^(PMFriendsResponse *response) {
                @strongify(self)
                PMFriendshipRequestsViewModelImpl *viewModel = self.containerLogic.viewModel;
                viewModel.totalCount = response.meta.totalCount;
            }]
            map:^RACTuple *(PMFriendsResponse *response) {
                return RACTuplePack(response.friends, response.meta);
            }];
    }
    else {
        return [[[self.friendsApiClient getFriendsOfDreamer:self.context.idx filterForm:self.filterForm page:page]
            doNext:^(PMFriendsResponse *response) {
                @strongify(self)
                PMFriendshipRequestsViewModelImpl *viewModel = self.containerLogic.viewModel;
                viewModel.totalCount = response.meta.totalCount;
            }]
            map:^RACTuple *(PMFriendsResponse *response) {
                return RACTuplePack(response.friends, response.meta);
            }];
    }
}

- (RACSignal *)loadData
{
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    return [[RACSignal
        combineLatest:@[[super loadData],
                        containerLogicLoadData]]
        takeUntil:self.cancelSignal];
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

- (NSUInteger)perPage
{
    return 15;
}

#pragma mark - commands

- (RACCommand *)createToDreambookCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *index) {
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:index];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDreambookVCFromListFriendsVC context:context];
        return [RACSignal empty];
    }]; 
}

- (RACCommand *)CreateUpdateDateCommand
{
    return self.loadDataCommand;
}

@end
