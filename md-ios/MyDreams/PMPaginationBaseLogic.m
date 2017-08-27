//
//  PMPaginationBaseLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 27.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMBaseLogic+Protected.h"
#import "PMPage.h"
#import "PMPaginationResponseMeta.h"

@interface PMPaginationBaseLogic ()
@property (assign, nonatomic) BOOL hasNextPage;
@property (strong, nonatomic) RACCommand *loadNextPage;
@property (strong, nonatomic) PMPage *currentPage;
@property (strong, nonatomic) NSArray<PMBaseModel *> *items;
@property (assign, nonatomic) NSInteger totalCount;
@end

@implementation PMPaginationBaseLogic

- (void)startLogic
{
    [super startLogic];
    @weakify(self);
    
    if (!self.ignoreDataEmpty) {
        [RACObserve(self, items) subscribeNext:^(NSArray *items) {
            @strongify(self);
            self.isDataLoaded = (items.count > 0);
        }];
    }
    
    self.loadNextPage = [[RACCommand alloc] initWithEnabled:RACObserve(self, hasNextPage) signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self loadPage:[self nextPage]]
            flattenMap:^RACStream *(RACTuple *x) {
                [self applyPaginationMeta:x.second];

                //load next page if we recive zero new items
                NSUInteger count = [self mergeNewItems:x.first];
                return (count > 0) ? [RACSignal return:x.first] : [self loadPage:[self nextPage]];
            }];
    }];
}

- (RACCommand *)createLoadDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loadData];
    }];
}

- (RACSignal *)loadData
{
    [self resetPagination];
    return [[self loadPage:self.currentPage]
        doNext:^(RACTuple *x) {
            [self applyPaginationMeta:x.second];
            self.items = x.first;
        }];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [RACSignal empty];
}

- (void)resetPagination
{
    if (self.currentPage) {
        [self.currentPage updatePage:1 per:self.perPage];
    }
    else {
        self.currentPage = [[PMPage alloc] initWithPage:1 per:self.perPage];
    }
    self.hasNextPage = NO;
}

- (NSUInteger)perPage
{
    return 10;
}

#pragma mark - private

- (PMPage *)nextPage
{
    NSUInteger nextPage = [self.currentPage.page unsignedIntegerValue] + 1;
    return [[PMPage alloc] initWithPage:nextPage per:[self perPage]];
}

- (PMPage *)prevPage
{
    NSUInteger prevPage = [self.currentPage.page unsignedIntegerValue] - 1;
    return [[PMPage alloc] initWithPage:prevPage per:[self perPage]];
}

- (PMPage *)pageFromPaginationResponseMeta:(PMPaginationResponseMeta *)meta
{
    return [[PMPage alloc] initWithPage:meta.page per:meta.per];
}

- (NSUInteger)mergeNewItems:(NSArray *)newItems
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:self.items];
    NSArray *itemsIdx = [self.items valueForKey:PMSelectorString(idx)];
    
    __block NSUInteger newItemsCount = 0;
    
    [newItems enumerateObjectsUsingBlock:^(PMBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![itemsIdx containsObject:obj.idx]) {
            [items addObject:obj];
            newItemsCount++;
        }
    }];
    
    self.items = items;
    return newItemsCount;
}

- (void)applyPaginationMeta:(PMPaginationResponseMeta *)meta
{
    self.currentPage = [self pageFromPaginationResponseMeta:meta];
    self.hasNextPage = (meta.page < meta.pagesCount);
    self.totalCount = meta.totalCount;
}

@end
