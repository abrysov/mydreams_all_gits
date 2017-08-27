//
//  PMListDreamsLogic.m
//  myDreams
//
//  Created by AlbertA on 25/04/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListDreamsLogic.h"
#import "PMDreamApiClient.h"
#import "PMDreamFilterForm.h"
#import "PMDreamsViewModelImpl.h"
#import "PMDreamsResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseModelIdxContext.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMDreamMapper.h"

NSString * const PMListDreamsLogicErrorDomain = @"com.mydreams.ListDreams.logic.error";

@interface PMListDreamsLogic ()
@property (strong, nonatomic) PMDreamsViewModelImpl *dreamsViewModel;
@property (strong, nonatomic) PMDreamFilterForm *dreamFilterForm;

@property (strong, nonatomic) RACCommand *likedDreamsCommand;
@property (strong, nonatomic) RACCommand *hotDreamsCommand;
@property (strong, nonatomic) RACCommand *freshDreamsCommand;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;

@property (strong, nonatomic) RACChannelTerminal *searchTerminal;

@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMListDreamsLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dreamFilterForm = [self dreamFilterFormForFresh];
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
    
    self.likedDreamsCommand = [self createLikedDreamsCommand];
    self.hotDreamsCommand = [self createHotDreamsCommand];
    self.freshDreamsCommand = [self createFreshDreamsCommand];
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

- (RACCommand *)createLikedDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForLiked];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createHotDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForHot];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createFreshDreamsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        self.dreamFilterForm = [self dreamFilterFormForFresh];
        return [self.loadDataCommand execute:input];
    }];
}

- (RACCommand *)createToFullDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *postIdx) {
        @strongify(self);
        PMBaseModelIdxContext *context = [PMBaseModelIdxContext contextWithIdx:postIdx];
        [self performSegueWithIdentifier:kPMSegueIdentifierToDetailedDreamVCFromListDreamsVC context:context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

- (PMDreamFilterForm *)dreamFilterFormForLiked
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isLiked = @YES;
    return dreamFilterForm;
}

- (PMDreamFilterForm *)dreamFilterFormForHot
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isHot = @YES;
    return dreamFilterForm;
}

- (PMDreamFilterForm *)dreamFilterFormForFresh
{
    PMDreamFilterForm *dreamFilterForm = [[PMDreamFilterForm alloc] init];
    dreamFilterForm.isNew = @YES;
    return dreamFilterForm;
}

@end
