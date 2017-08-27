//
//  PMListDreamersLogic.m
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListDreamersLogic.h"
#import "PMDreamersViewModelImpl.h"
#import "PMDreamerFilterForm.h"
#import "PMDreamerApiClient.h"
#import "PMDreamersResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMFiltersDreamersContext.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMBaseModelIdxContext.h"
#import "PMDreamerMapper.h"

NSString * const PMListDreamersLogicErrorDomain = @"com.mydreams.ListDreamers.logic.error";

@interface PMListDreamersLogic ()
@property (strong, nonatomic) PMFiltersDreamersContext *context;
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
@property (strong, nonatomic) PMDreamersViewModelImpl *dreamersViewModel;

@property (strong, nonatomic) RACCommand *showFiltersDreamersCommand;
@property (strong, nonatomic) RACCommand *removeFiltersCommand;
@property (strong, nonatomic) RACCommand *toDreambookCommand;

@property (strong, nonatomic) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListDreamersLogic
@dynamic context;

- (void)startLogic
{
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    
    [super startLogic];
    @weakify(self);
  
    self.searchTerminal = RACChannelTo(self, filterForm.search);
    self.dreamersViewModel = [[PMDreamersViewModelImpl alloc] init];
    self.dreamersViewModel.dreamers = @[];
    

    self.showFiltersDreamersCommand = [self createShowFiltersDreamersCommand];
    self.removeFiltersCommand = [self createRemoveFiltersCommand];
    self.toDreambookCommand = [self createToDreambookCommand];

    RAC(self, dreamersViewModel.dreamers) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self.dreamerMapper dreamersToViewModels:items paginationLogic:self];
        }];
    
    [[[[RACObserve(self, context)
        skip:1]
        ignore:nil]
        distinctUntilChanged]
        subscribeNext:^(PMFiltersDreamersContext *context) {
            @strongify(self);
            self.filterForm = context.filterForm;
            [self.loadDataCommand execute:nil];
            self.dreamersViewModel = [[PMDreamersViewModelImpl alloc] initWithFilterForm:context.filterForm];
        }];
    
    self.cancelSignal = [RACSubject subject];

    [[[[[[RACObserve(self, filterForm.search)
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
    @weakify(self);
    return [[[self.dreamerApiClient getDreamers:self.filterForm page:page]
            doNext:^(PMDreamersResponse *response) {
                @strongify(self)
                [(PMDreamersViewModelImpl *) self.dreamersViewModel updateTotalCount:@(response.meta.totalCount)];
            }]
            map:^RACTuple *(PMDreamersResponse *response) {
                return RACTuplePack(response.dreamers, response.meta);
            }];
}

- (RACSignal *)loadData
{
    RACSignal *signal = [super loadData];
    return [signal takeUntil:self.cancelSignal];
}

- (NSUInteger)perPage
{
    return 15;
}

- (RACCommand *)createRemoveFiltersCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self defaultValue];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createShowFiltersDreamersCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        PMFiltersDreamersContext *context = [PMFiltersDreamersContext contextWithFilterForm:self.filterForm];
        [self performSegueWithIdentifier:kPMSegueIdentifierToFiltersDreamersVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToDreambookCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *dreamerIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:dreamerIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDreambookVCFromListDreamers context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

- (void)defaultValue
{
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    self.dreamersViewModel = [[PMDreamersViewModelImpl alloc] initWithFilterForm:self.filterForm];
}

@end
