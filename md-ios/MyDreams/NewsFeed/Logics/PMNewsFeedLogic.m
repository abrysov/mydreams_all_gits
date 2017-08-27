//
//  PMNewsFeedLogic.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsFeedLogic.h"
#import "PMNewsFeedViewModelImpl.h"
#import "PMPostMapper.h"
#import "PMPostApiClient.h"
#import "PMFeedsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseLogic+Protected.h"
#import "PMNewsSegues.h"
#import "PMBaseModelIdxContext.h"
#import "PMSubjectContext.h"
#import "PMPaginationBaseLogic+Protected.h"

NSString * const PMNewsFeedLogicErrorDomain = @"com.mydreams.NewsFeed.logic.error";

@interface PMNewsFeedLogic ()
@property (strong, nonatomic) PMNewsFeedViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@property (strong, nonatomic) RACCommand *createPostCommand;
@property (nonatomic, strong) RACSubject *createdPostsSubject;
@end

@implementation PMNewsFeedLogic

- (void)startLogic
{
    PMNewsFeedViewModelImpl *viewModel = [[PMNewsFeedViewModelImpl alloc] init];
    viewModel.items = @[];
    self.viewModel = viewModel;
    
    [super startLogic];
    self.createdPostsSubject = [RACSubject subject];
    self.toFullPostCommand = [self createToFullPostCommand];
    self.createPostCommand = [self createCreatePostCommand];
    
    @weakify(self);
    RAC(self.viewModel, items) = [RACObserve(self, items)
        map:^id(NSArray *posts) {
            @strongify(self);
            return [self.postMapper postsToViewModels:posts paginationLogic:self];
        }];
    
    [self.createdPostsSubject subscribeNext:^(PMPost *post) {
        @strongify(self);
        [self appendItem:post atIndex:0];
        PMNewsFeedViewModelImpl *viewModel = self.viewModel;
        viewModel.postsCountInteger = viewModel.postsCountInteger + 1;
    }];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    @weakify(self);
    return [[[self.postApiClient getFeeds:page]
        doNext:^(PMFeedsResponse *response) {
            @strongify(self);
            PMNewsFeedViewModelImpl *viewModel = self.viewModel;
            viewModel.postsCountInteger = response.meta.totalCount;
        }]
        map:^id(PMFeedsResponse *response) {
            return RACTuplePack(response.feeds, response.meta);
        }];
}

#pragma mark - commands
                                   
- (RACCommand *)createToFullPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierNewsToDetailedPostVCFromNewsFeedVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createCreatePostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierNewsToCreatePostVCFromNewsFeedVC context:[PMSubjectContext contextWithSubject:self.createdPostsSubject]];
        return [RACSignal empty];
    }];
}

#pragma mark - private

@end
