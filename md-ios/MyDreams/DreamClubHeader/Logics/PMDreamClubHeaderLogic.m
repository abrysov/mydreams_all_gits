//
//  PMDreamClubHeaderPMDreamClubHeaderLogic.m
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubHeaderLogic.h"
#import "PMDreamClubHeaderViewModelImpl.h"
#import "PMDreamerResponse.h"
#import "PMImageDownloader.h"
#import "PMDreambookHeaderViewItemType.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseLogic+Protected.h"
#import "PMBaseModelIdxWithIsMineContext.h"
#import "PMDreamclubSegues.h"
#import "PMDreamclubWrapperApiClient.h"

NSString * const PMDreamClubHeaderLogicErrorDomain = @"com.mydreams.DreamClubHeader.logic.error";

@interface PMDreamClubHeaderLogic ()
@property (strong, nonatomic) PMDreamClubHeaderViewModelImpl *viewModel;
@property (nonatomic, strong) RACCommand *toSectionCommand;
@property (nonatomic, strong) RACCommand *sendMessageCommand;
@property (nonatomic, strong) NSNumber *dreamclubIdx;
@end

@implementation PMDreamClubHeaderLogic

- (void)startLogic
{
    [super startLogic];
    self.toSectionCommand = [self createToSectionCommand];
    self.sendMessageCommand = [self createSendMessageCommand];
}

- (RACSignal *)loadData
{
    @weakify(self);
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    
    return [[RACSignal
        combineLatest:@[[self.dreamclubWrapperApiClient getDreamclub],
                        containerLogicLoadData]]
        doNext:^(RACTuple *tuple) {
            @strongify(self);
            PMDreamerResponse *response = tuple.first;
            self.dreamclubIdx = response.dreamer.idx;
            [self createViewModelWithDreamer:response.dreamer];
        }];
}

#pragma mark - private

- (void)createViewModelWithDreamer:(PMDreamer *)dreamer
{
    PMDreamClubHeaderViewModelImpl *viewModel = [[PMDreamClubHeaderViewModelImpl alloc] initWithDreamer:dreamer];
    
    NSURL *avatarUrl = [NSURL URLWithString:dreamer.avatar.large];
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
    self.viewModel = viewModel;
}

- (RACCommand *)createSendMessageCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToSectionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        PMDreambookHeaderViewItemType type = [input unsignedIntValue];
        NSString *segueIdentifier;
        PMBaseContext *context;
        
        @strongify(self);
        switch (type) {
            case PMDreambookHeaderViewItemTypeSubscribers: {
                context = [PMBaseModelIdxContext contextWithIdx:self.dreamclubIdx];
                segueIdentifier = kPMSegueIdentifierToListFollowersVCFromDreamclubHeaderVC;
                break;
            }
            case PMDreambookHeaderViewItemTypeDreams: {
                context = [PMBaseModelIdxContext contextWithIdx:self.dreamclubIdx];
                segueIdentifier = kPMSegueIdentifierToPersonalListDreamsVCFromDreamclubHeaderVC;
                break;
            }
            case PMDreambookHeaderViewItemTypeFulfilledDreams: {
                context = [PMBaseModelIdxContext contextWithIdx:self.dreamclubIdx];
                segueIdentifier = kPMSegueIdentifierToPersonalListFulfilledDreamsVCFromDreamclubHeaderVC;
                break;
            }
            case PMDreambookHeaderViewItemTypeFriends: {
                context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamclubIdx isMine:NO];
                segueIdentifier = kPMSegueIdentifierToListFriendsVCFromDreamclubHeaderVC;
                break;
            }
            case PMDreambookHeaderViewItemTypePhotos: {
                context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamclubIdx isMine:NO];
                segueIdentifier = kPMSegueIdentifierToListPhotosVCFromDreamclubHeaderVC;
                break;
            }
            case PMDreambookHeaderViewItemTypeMarks: {
                context = [PMBaseModelIdxWithIsMineContext contextWithIdx:self.dreamclubIdx isMine:NO];
                segueIdentifier = kPMSegueIdentifierToListCertificatesVCFromDreamclubHeaderVC;
                break;
            }
            default:
                return [RACSignal empty];
        }
        [self performSegueWithIdentifier:segueIdentifier context:context];
        return [RACSignal empty];
    }];
}

@end
