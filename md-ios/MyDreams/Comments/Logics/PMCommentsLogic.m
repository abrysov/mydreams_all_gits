//
//  PMCommentsLogic.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCommentsLogic.h"
#import "PMPostApiClient.h"
#import "PMNewsSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMBaseModelIdxContext.h"
#import "PMFeedCommentsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMPostMapper.h"
#import "PMCommentsViewModelImpl.h"

NSString * const PMCommentsLogicErrorDomain = @"com.mydreams.Comments.logic.error";

@interface PMCommentsLogic ()
@property (strong, nonatomic) PMCommentsViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@property (nonatomic, strong) RACChannelTerminal *selectSourceTypeTerminal;
@property (assign, nonatomic) PMSourceType sourceType;
@end

@implementation PMCommentsLogic

- (void)startLogic
{
    PMCommentsViewModelImpl *viewModel = [[PMCommentsViewModelImpl alloc] init];
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
    return [[self.postApiClient getFeedComments:self.sourceType page:page]
        map:^id(PMFeedCommentsResponse *response) {
            return RACTuplePack(response.comments, response.meta);
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
