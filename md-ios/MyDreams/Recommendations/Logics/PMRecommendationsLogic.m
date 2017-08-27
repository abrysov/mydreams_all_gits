//
//  PMRecommendationsLogic.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRecommendationsLogic.h"
#import "PMPostApiClient.h"
#import "PMNewsSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMBaseModelIdxContext.h"
#import "PMPaginationResponseMeta.h"
#import "PMPostMapper.h"
#import "PMRecommendationsViewModelImpl.h"
#import "PMFeedRecommendationsResponse.h"

NSString * const PMRecommendationsLogicErrorDomain = @"com.mydreams.Recommendations.logic.error";

@interface PMRecommendationsLogic ()
@property (strong, nonatomic) PMRecommendationsViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@property (nonatomic, strong) RACChannelTerminal *selectSourceTypeTerminal;
@property (assign, nonatomic) PMSourceType sourceType;
@end

@implementation PMRecommendationsLogic

- (void)startLogic
{
    PMRecommendationsViewModelImpl *viewModel = [[PMRecommendationsViewModelImpl alloc] init];
    viewModel.items = @[];
    self.viewModel = viewModel;
    
    [super startLogic];
    self.toFullPostCommand = [self createToFullPostCommand];
    self.selectSourceTypeTerminal = RACChannelTo(self, sourceType);
    
    @weakify(self);
    RAC(self.viewModel, items) = [RACObserve(self, items)
        map:^id(NSArray *posts) {
            @strongify(self);
            return [self.postMapper postsToViewModels:posts paginationLogic:self];
        }];
    
    [[RACObserve(self, sourceType) distinctUntilChanged] subscribeNext:^(NSNumber *input) {
        [self.loadDataCommand execute:input];
    }];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [[self.postApiClient getFeedRecommendations:self.sourceType page:page]
        map:^id(PMFeedRecommendationsResponse *response) {
            return RACTuplePack(response.recommendations, response.meta);
        }];
}

#pragma mark - commands

- (RACCommand *)createToFullPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierNewsToDetailedPostVCFromCommentsVC context:context];
        return [RACSignal empty];
    }];
}

@end
