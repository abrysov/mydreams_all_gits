//
//  PMFiltersDreamersLogic.m
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFiltersDreamersLogic.h"
#import "PMFiltersDreamersContext.h"
#import "PMDreamerFilterForm.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMPaginationResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMFiltersDreamersViewModelImpl.h"
#import "PMDreamerApiClient.h"
#import "PMLocationContext.h"
#import "PMLocality.h"
#import "PMLocation.h"

NSString * const PMFiltersDreamersLogicErrorDomain = @"com.mydreams.FiltersDreamers.logic.error";

@interface PMFiltersDreamersLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *toSelectCountryCommand;
@property (nonatomic, strong) RACCommand *toSelectLocalityCommand;
@property (nonatomic, strong) RACCommand *resetFiltersCommand;
@property (nonatomic, strong) RACCommand *changeAllOptionCommand;
@property (nonatomic, strong) RACCommand *changeNewOptionCommand;
@property (nonatomic, strong) RACCommand *changeTopOptionCommand;
@property (nonatomic, strong) RACCommand *changeVipOptionCommand;
@property (nonatomic, strong) RACCommand *changeOnlineOptionCommand;
@property (nonatomic, strong) PMFiltersDreamersViewModelImpl *viewModel;
@property (nonatomic, strong) PMFiltersDreamersContext *context;
@property (nonatomic, strong) RACChannelTerminal *fromAgeTerminal;
@property (nonatomic, strong) RACChannelTerminal *toAgeTerminal;
@property (nonatomic, strong) RACChannelTerminal *selectGenderTerminal;
@property (nonatomic, strong) RACDisposable *getDreamersCountDisposable;
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;

@end

@implementation PMFiltersDreamersLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];

    RACSignal *countryNotEmptySignal = [RACObserve(self, filterForm.countryId) map:^id(NSNumber *country) {
        return @(country != nil);
    }];
    
    self.backCommand = [self createBackCommand];
    self.toSelectCountryCommand = [self createToSelectCountryCommand];
    self.toSelectLocalityCommand = [self createToSelectLocalityCommandWithEnabledSignal:countryNotEmptySignal];
    
    self.resetFiltersCommand = [self createResetFiltersCommand];
    self.changeAllOptionCommand = [self createchangeAllOptionCommand];
    self.changeNewOptionCommand = [self createchangeNewOptionCommand];
    self.changeTopOptionCommand = [self createchangeTopOptionCommand];
    self.changeVipOptionCommand = [self createchangeVipOptionCommand];
    self.changeOnlineOptionCommand = [self createchangeOnlineOptionCommand];
    
    @weakify(self);
    self.fromAgeTerminal = RACChannelTo(self, filterForm.ageFrom);
    self.toAgeTerminal = RACChannelTo(self, filterForm.ageTo);
    self.selectGenderTerminal = RACChannelTo(self, filterForm.gender);

    [[RACObserve(self, context.filterForm) ignore:nil]
        subscribeNext:^(PMDreamerFilterForm *form) {
            @strongify(self);
            self.filterForm = form;
        }];
    
    RACSignal *createViewModelSignal  = [[RACObserve(self, filterForm)
        distinctUntilChanged]
        map:^id<PMFiltersDreamersViewModel>(PMDreamerFilterForm *form) {
            return [[PMFiltersDreamersViewModelImpl alloc] initWithFilterForm:form];
        }];
    
     RAC(self, viewModel) = createViewModelSignal;
    
    [[[RACSignal merge:@[
            createViewModelSignal,
            [RACObserve(self, filterForm.ageTo) skip:1],
            [RACObserve(self, filterForm.ageFrom) skip:1],
            [RACObserve(self, filterForm.gender) skip:1],
            [RACObserve(self, filterForm.countryId) skip:1],
            [RACObserve(self, filterForm.cityId) skip:1]
        ]]
        ignore:nil]
        subscribeNext:^(id x) {
            @strongify(self);
            [self getDreamersCount];
        }];
}

#pragma mark - private

- (RACCommand *)createToSelectCountryCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        PMLocationContext *context = [PMLocationContext contextWithSubject:subject];
        [subject subscribeNext:^(PMLocation *x) {
            self.filterForm.country = x.name;
            self.filterForm.countryId = x.idx;
        }];
        [self performSegueWithIdentifier:kPMSegueIdentifierToSelectCountryFilterVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createToSelectLocalityCommandWithEnabledSignal:(RACSignal *)signal
{
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:signal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        RACSubject *subject = [RACSubject subject];
        PMLocationContext *context = [PMLocationContext contextWithSubject:subject];
        context.countryIdx = self.filterForm.countryId;
        [subject subscribeNext:^(PMLocality *x) {
            self.filterForm.city = x.name;
            self.filterForm.cityId = x.idx;
        }];
        [self performSegueWithIdentifier:kPMSegueIdentifierToSelectLocalityFilterVC context:context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        PMFiltersDreamersContext *context = [PMFiltersDreamersContext contextWithFilterForm:self.filterForm];
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseFiltersDreamersVC context:context];
        return [RACSignal empty];
    }];
}


- (RACCommand *)createchangeAllOptionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        self.filterForm.isNew = nil;
        self.filterForm.isVip = nil;
        self.filterForm.isOnline = nil;
        self.filterForm.isTop = nil;
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createchangeNewOptionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        self.filterForm.isNew = self.filterForm.isNew ? nil : @YES;
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createchangeTopOptionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        self.filterForm.isTop = self.filterForm.isTop ? nil : @YES;
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createchangeVipOptionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        self.filterForm.isVip = self.filterForm.isVip ? nil : @YES;
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createchangeOnlineOptionCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        self.filterForm.isOnline = self.filterForm.isOnline ? nil : @YES;
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createResetFiltersCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal  *(id input) {
        @strongify(self);
        [self defaultValue];
        [self getDreamersCount];
        return [RACSignal empty];
    }];
}

- (void)getDreamersCount
{
    [self.getDreamersCountDisposable dispose];
    @weakify(self);
    self.getDreamersCountDisposable = [[self.dreamerApiClient getDreamers:self.filterForm page:[[PMPage alloc] initWithPage:1 per:0]]
        subscribeNext:^(PMPaginationResponse *response)  {
            @strongify(self);
            if (response.meta.totalCount == 0) {
                [(PMFiltersDreamersViewModelImpl *)self.viewModel receiveNotFound];
            } else {
                [(PMFiltersDreamersViewModelImpl *)self.viewModel updateTotalCount:response.meta.totalCount];
            }
        }];
}

- (void)defaultValue
{
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    self.viewModel = [[PMFiltersDreamersViewModelImpl alloc] initWithFilterForm:self.filterForm];
}

@end
