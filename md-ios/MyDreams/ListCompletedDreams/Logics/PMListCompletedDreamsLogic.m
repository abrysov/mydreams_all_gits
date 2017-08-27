//
//  PMListCompletedDreamsLogic.m
//  myDreams
//
//  Created by AlbertA on 28/04/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListCompletedDreamsLogic.h"
#import "PMDreamApiClient.h"
#import "PMDreamFilterForm.h"
#import "PMDreamsViewModelImpl.h"
#import "PMDreamsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMBaseModelIdxContext.h"
#import "PMDreamMapper.h"

NSString * const PMListCompletedDreamsLogicErrorDomain = @"com.mydreams.ListCompletedDreams.logic.error";

@interface PMListCompletedDreamsLogic ()
@property (strong, nonatomic) PMDreamsViewModelImpl *dreamsViewModel;
@property (strong, nonatomic) PMDreamFilterForm *dreamFilterForm;

@property (strong, nonatomic) RACCommand *allDreamsCommand;
@property (strong, nonatomic) RACCommand *maleDreamsCommand;
@property (strong, nonatomic) RACCommand *femaleDreamsCommand;
@property (strong, nonatomic) RACCommand *toAddDreamCommand;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;
@property (strong, nonatomic) RACChannelTerminal *searchTerminal;

@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListCompletedDreamsLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dreamFilterForm = [self dreamFilterFormForAll];
    }
    return self;
}

- (void)startLogic
{
    [super startLogic];
    @weakify(self);
    
    self.searchTerminal = RACChannelTo(self, dreamFilterForm.search);
    
    self.dreamsViewModel = [[PMDreamsViewModelImpl alloc] init];
    self.dreamsViewModel.dreams = @[];
    
    self.toAddDreamCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierToAddFulfillDreamVC];
    
    self.allDreamsCommand = [self createAllDreamsCommand];
    self.maleDreamsCommand = [self createMaleDreamsCommand];
    self.femaleDreamsCommand = [self createFemaleDreamsCommand];
    self.toFullDreamCommand = [self createToFullDreamCommand];
    
    RAC(self.dreamsViewModel, dreams) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self.dreamMapper dreamsToViewModels:items paginationLogic:self];
        }];
    
    self.cancelSignal = [RACSubject subject];
    
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
}

- (RACSignal *)loadPage:(PMPage *)page
{
    return [[self.dreamApiClient getDreams:self.dreamFilterForm page:page]
            map:^RACTuple *(PMDreamsResponse *response) {
                return RACTuplePack(response.dreams, response.meta);
            }];
}

- (RACSignal *)loadData
{
    RACSignal *signal = [super loadData];
    return [signal takeUntil:self.cancelSignal];
}

#pragma mark - commands

- (RACCommand *)createCancelSearchCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm.search = @"";
        return  [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createAllDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForAll];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createMaleDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForMale];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createFemaleDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForFemale];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createToFullDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDetailedDreamVCFromListCompletedDreamsVC context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - forms

- (PMDreamFilterForm *)dreamFilterFormForAll
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isFulfilled = @YES;
    return dreamFilterForm;
}

- (PMDreamFilterForm *)dreamFilterFormForMale
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isFulfilled = @YES;
    dreamFilterForm.gender = PMDreamerGenderMale;
    return dreamFilterForm;
}

- (PMDreamFilterForm *)dreamFilterFormForFemale
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isFulfilled = @YES;
    dreamFilterForm.gender = PMDreamerGenderFemale;
    return dreamFilterForm;
}

@end
