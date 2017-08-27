//
//  PMDreamClubPMDreamClubLogic.m
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubLogic.h"
#import "PMDreamClubViewModelImpl.h"
#import "PMPostMapper.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseLogic+Protected.h"
#import "PMFeedsResponse.h"
#import "PMBaseModelIdxContext.h"
#import "PMDreamclubSegues.h"
#import "PMDreamclubWrapperApiClient.h"

NSString * const PMDreamClubLogicErrorDomain = @"com.mydreams.DreamClub.logic.error";

@interface PMDreamClubLogic ()
@property (strong, nonatomic) PMDreamClubViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@end

@implementation PMDreamClubLogic

- (void)startLogic
{
    self.ignoreDataEmpty = YES;
    PMDreamClubViewModelImpl *viewModel = [[PMDreamClubViewModelImpl alloc] init];
    viewModel.items = @[];
    self.viewModel = viewModel;
    
    [super startLogic];
    self.toFullPostCommand = [self createToFullPostCommand];

    @weakify(self);
    RAC(self.viewModel, items) = [RACObserve(self, items)
        map:^id(NSArray *posts) {
            @strongify(self);
            return [self.postMapper postsToViewModels:posts paginationLogic:self];
        }];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [[self.dreamclubWrapperApiClient getDreamclubFeeds:page]
        map:^id(PMFeedsResponse *response) {
            return RACTuplePack(response.feeds, response.meta);
        }];
}

- (RACSignal *)loadData
{
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    return [RACSignal combineLatest:@[[super loadData],
                                      containerLogicLoadData]];
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

- (RACCommand *)createToFullPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDetailedPostVCFromDreamclubVC context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

@end
