//
//  PMSearchLogic.m
//  myDreams
//
//  Created by AlbertA on 26/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchLogic.h"
#import "PMSearchViewModelImpl.h"
#import "PMDreamerFilterForm.h"
#import "PMDreamFilterForm.h"
#import "PMDreamApiClient.h"
#import "PMDreamerApiClient.h"
#import "PMPostApiClient.h"
#import "PMDreamsResponse.h"
#import "PMDreamersResponse.h"
#import "PMFeedsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "MenuSegues.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseLogic+Protected.h"
#import "PMDreamMapper.h"
#import "PMDreamerMapper.h"
#import "PMPostMapper.h"

NSString * const PMSearchLogicErrorDomain = @"com.mydreams.Search.logic.error";

@interface PMSearchLogic ()
@property (strong, nonatomic) PMSearchViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *searchItemsCommand;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;

@property (strong, nonatomic) RACSubject *cancelSignal;
@property (strong, nonatomic) NSString *search;
@property (assign, nonatomic) PMSearchType itemsType;
@end

@implementation PMSearchLogic

- (void)startLogic
{
    PMSearchViewModelImpl *viewModel = [[PMSearchViewModelImpl alloc] init];
    viewModel.items = @[];
    self.viewModel = viewModel;
    
    [super startLogic];
    
    self.searchItemsCommand = [self createSearchItemsCommand];
    self.toFullDreamCommand = [self createToFullDreamCommand];
    self.toDreambookCommand = [self createToDreambookCommand];
    self.toFullPostCommand = [self createToFullPostCommand];
    self.searchTerminal = RACChannelTo(self, search);
    
    RAC(self, viewModel.type) = RACObserve(self, itemsType);
    
    @weakify(self);
    RAC(self.viewModel, items) = [[RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            switch (self.itemsType) {
                case PMSearchTypeDream:
                    return [self.dreamMapper dreamsToViewModels:items paginationLogic:self];
                case PMSearchTypeDreamer:
                    return [self.dreamerMapper dreamersToViewModels:items paginationLogic:self];
                case PMSearchTypePost:
                    return [self.postMapper postsToViewModels:items paginationLogic:self];
                default:
                    return @[];
            }
        }] takeUntil:self.cancelSignal];
    
    
    self.cancelSignal = [RACSubject subject];
    
    [[[[[[RACObserve(self, search)
        skip:1]
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
    RACSignal *getItems = nil;
    
    switch (self.itemsType) {
        case PMSearchTypeDream:
            getItems = [self getDreamsWithPage:page];
            break;
        case PMSearchTypeDreamer:
            getItems = [self getDreamersWithPage:page];
            break;
        case PMSearchTypePost:
            getItems = [self getPostsWithPage:page];
            break;
        default:
            getItems = [RACSignal empty];
            break;
    }
    return [getItems takeUntil:self.cancelSignal];
}

- (RACSignal *)loadData
{
    RACSignal *signal = [super loadData];
    return [signal takeUntil:self.cancelSignal];
}

#pragma mark - commands

- (RACCommand *)createSearchItemsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        @strongify(self);
        [self.cancelSignal sendNext:input];
        self.itemsType = [input unsignedIntValue];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createToFullDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *dreamIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:dreamIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierMenuToDetailedDreamVCFromSearchVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToFullPostCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierMenuToDetailedPostVCFromSearchVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToDreambookCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *dreamerIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:dreamerIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierMenuToDreambookVCFromSearchVC context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

- (RACSignal *)getDreamsWithPage:(PMPage *)page
{
    PMDreamFilterForm *form = [[PMDreamFilterForm alloc] init];
    form.search = self.search;
    return [[[self.dreamApiClient getDreams:form page:page] map:^id(PMDreamsResponse *response) {
        return RACTuplePack(response.dreams, response.meta);
    }]takeUntil:self.cancelSignal];
}

- (RACSignal *)getDreamersWithPage:(PMPage *)page
{
    PMDreamerFilterForm *form = [[PMDreamerFilterForm alloc] init];
    form.search = self.search;
    return [[[self.dreamerApiClient getDreamers:form page:page] map:^id(PMDreamersResponse *response) {
        return RACTuplePack(response.dreamers, response.meta);
    }] takeUntil:self.cancelSignal];
}

- (RACSignal *)getPostsWithPage:(PMPage *)page
{
    return  [[[self.postApiClient getPostsWithSearch:self.search page:page] map:^id(PMFeedsResponse *response) {
        return RACTuplePack(response.feeds, response.meta);
    }] takeUntil:self.cancelSignal];
}

@end
