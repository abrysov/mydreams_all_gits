//
//  PMSelectLocalityLogic.m
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectLocalityLogic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMLocalitiesViewModelImpl.h"
#import "PMLocalitiesResponse.h"
#import "PMLocalityForm.h"
#import "PMLocalityViewModelImpl.h"
#import "PMCustomLocalityResponse.h"
#import "PMUserContext.h"

NSString * const PMSelectLocalityLogicErrorDomain = @"com.mydreams.SelectLocality.logic.error";

@interface PMSelectLocalityLogic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *showProposeLocalityCommand;
@property (nonatomic, strong) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSArray *localities;
@end

@implementation PMSelectLocalityLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
    self.showProposeLocalityCommand = [self createShowProposeLocalityCommand];
    self.searchTerminal = RACChannelTo(self, searchRequest);

    @weakify(self);
    [[[[RACObserve(self, searchRequest)
        skip:1]
        map:^id(NSString *term) {
            @strongify(self);
            return [[self.locationService localitiesListCountry:self.context.userForm.country.idx searchTerm:term] catch:^RACSignal *(NSError *error) {
                return [RACSignal return:nil];
            }];
        }]
        switchToLatest]
        subscribeNext:^(PMLocalitiesResponse *localitiesResponse) {
            @strongify(self);
            [self applyLocalitiesResponse:localitiesResponse];
        }];
}

- (void)selectLocalityWithIndex:(NSInteger)index
{
    PMLocality *locality = self.localities[index];
    self.context.userForm.locality = locality;
    [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectLocalityVCInRegistrationStep3VC context:self.context];
}

#pragma mark - private

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.locationService localitiesListCountry:self.context.userForm.country.idx] doNext:^(PMLocalitiesResponse *response) {
        @strongify(self);
        [self applyLocalitiesResponse:response];
    }];
}

- (void)applyLocalitiesResponse:(PMLocalitiesResponse *)response
{
    self.localities = response.localities;
    NSArray *localities = [[[response.localities rac_sequence]
                           map:^id(PMLocality *locality) {
                               return [[PMLocalityViewModelImpl alloc] initWithLocality:locality];
                           }] array];
    self.localitiesViewModel = [[PMLocalitiesViewModelImpl alloc] initWithLocalities:localities];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectLocalityVC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createShowProposeLocalityCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToProposeLocalityVC context:self.context];
        return [RACSignal empty];
    }];
}

@end
