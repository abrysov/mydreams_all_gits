//
//  PMRegistrationSelectionLocationLogic.m
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectCountryLogic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMCountriesResponse.h"
#import "PMCountryViewModelImpl.h"
#import "PMUserContext.h"

@interface PMSelectCountryLogic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *nextStepCommand;
@property (nonatomic, strong) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSArray *countries;
@end

@implementation PMSelectCountryLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
    self.nextStepCommand = [self createNextStepCommand];
    
    self.searchTerminal = RACChannelTo(self, searchRequest);
    
    @weakify(self);
    [[[[RACObserve(self, searchRequest)
       skip:1]
        map:^id(NSString *term) {
            @strongify(self);
            return [[self.locationService countriesListWithSearchTerm:term] catch:^RACSignal *(NSError *error) {
                return [RACSignal return:nil];
            }];
        }]
       switchToLatest]
       subscribeNext:^(PMCountriesResponse *countriesResponse) {
            @strongify(self);
            [self applyCountriesResponse:countriesResponse];
       }];
}

- (void) selectCountryWithIndex:(NSInteger)index
{
    PMLocation *country = self.countries[index];
    self.context.userForm.country  = country;
    self.context.userForm.locality = nil;
    [self performSegueWithIdentifier:kPMSegueIdentifierToSelectLocalityVC context:self.context];
}

- (RACCommand *)createNextStepCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationStep3VC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.locationService countriesList] doNext:^(PMCountriesResponse *countriesResponse) {
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
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectCountyVC context:self.context];
        return [RACSignal empty];
    }];
}

@end
