//
//  PMPersonalListFulfilledDreamsLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPersonalListFulfilledDreamsLogic.h"
#import "PMDreamsViewModelImpl.h"
#import "PMDreamFilterForm.h"
#import "PMDreamApiClient.h"
#import "PMDreamsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseModelIdxContext.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMDreamMapper.h"

@interface PMPersonalListFulfilledDreamsLogic ()
@property (strong, nonatomic) PMBaseModelIdxContext *context;
@property (strong, nonatomic) PMDreamsViewModelImpl *dreamsViewModel;
@property (strong, nonatomic) PMDreamFilterForm *dreamFilterForm;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;
@property (strong, nonatomic) RACSubject *cancelSignal;

@property (nonatomic, copy) NSNumber *dreamerId;
@property (nonatomic, assign, readonly) BOOL isForOwnDreams;
@end

@implementation PMPersonalListFulfilledDreamsLogic
@dynamic context;

- (void)startLogic
{
    @weakify(self);
    
    self.dreamFilterForm = [PMDreamFilterForm new];
    self.dreamFilterForm.isFulfilled = @YES;
    self.dreamerId = self.context.idx;
    
    self.dreamsViewModel = [[PMDreamsViewModelImpl alloc] init];
    self.dreamsViewModel.dreams = @[];
    
    self.cancelSignal = [RACSubject subject];
    
    self.searchTerminal = RACChannelTo(self, dreamFilterForm.search);
    
    RAC(self, localizedTitleKey) = [RACObserve(self, dreamerId) map:^id(id value) {
        return (value)? @"dreambook.list_completed_dreams.title" : @"dreambook.list_completed_dreams.own_dreams_title";
    }];
    
    RAC(self.dreamsViewModel, dreams) = [RACObserve(self, items)
    map:^id(NSArray *items) {
        @strongify(self);
        return [self.dreamMapper dreamsToViewModels:items paginationLogic:self];
    }];
    
    [[[[[[RACObserve(self, dreamFilterForm.search)
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

    [super startLogic];
    self.toFullDreamCommand = [self createToFullDreamCommand];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    RACSignal *loadDreams = nil;
    if ([self isForOwnDreams]) {
        loadDreams = [self.dreamApiClient getOwnDreams:self.dreamFilterForm page:page];
    }
    else {
        loadDreams = [self.dreamApiClient getDreamsOfDreamer:self.dreamerId form:self.dreamFilterForm page:page];
    }
    
    return [loadDreams map:^RACTuple *(PMDreamsResponse *response) {
        return RACTuplePack(response.dreams, response.meta);
    }];
}

- (RACSignal *)loadData
{
    RACSignal *signal = [super loadData];
    return [signal takeUntil:self.cancelSignal];
}

#pragma mark - private

- (RACCommand *)createToFullDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDetailedDreamVCFromPersonalListFulfilledDreamsVC context:context];
        return [RACSignal empty];
    }];
}

- (BOOL)isForOwnDreams {
    return !self.dreamerId;
}

@end
