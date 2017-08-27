//
//  PMSelectCountryFilterLogic.m
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectCountryFilterLogic.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMCountriesResponse.h"
#import "PMCountryViewModelImpl.h"
#import "PMLocationContext.h"


NSString * const PMSelectCountryFilterLogicErrorDomain = @"com.mydreams.SelectCountryFilter.logic.error";

@interface PMSelectCountryFilterLogic ()
@property (nonatomic, strong) PMLocationContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSArray *countries;
@property (strong, nonatomic) RACSubject *cancelSignal;
@end

@implementation PMSelectCountryFilterLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
    
    self.searchTerminal = RACChannelTo(self, searchRequest);
    
    @weakify(self);
    [[RACObserve(self, searchRequest)
        skip:1]
        subscribeNext:^(NSString *term) {
            @strongify(self);
            [self.loadDataCommand execute:self];
        }];
    
    self.cancelSignal = [RACSubject subject];
    
    [[[[[[RACObserve(self, searchRequest)
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

- (void)selectCountryWithIndex:(NSInteger)index
{
    PMLocation *country = self.countries[index]; 
    [self.context.localitySubject sendNext:country];
    
    [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectCountryFilterVC];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[[self.locationService countriesListWithSearchTerm:self.searchRequest]
        takeUntil:self.cancelSignal]
        doNext:^(PMCountriesResponse *countriesResponse) {
            @strongify(self);
            [self applyCountriesResponse:countriesResponse];
        }];
}

- (void)applyCountriesResponse:(PMCountriesResponse *)response
{
    self.countries = response.countries;
    NSArray *countries = [[[response.countries rac_sequence]
        map:^id(PMLocation *country) {
            return [[PMCountryViewModelImpl alloc] initWithCountry:country];
        }] array];
    
    self.countriesViewModel = [[PMCountriesViewModelImpl alloc] initWithCountries:countries];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectCountryFilterVC];
        return [RACSignal empty];
    }];
}


@end
