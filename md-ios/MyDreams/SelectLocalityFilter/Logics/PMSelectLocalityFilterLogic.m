//
//  PMSelectLocalityFilterLogic.m
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectLocalityFilterLogic.h"
#import "DreambookSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMLocalitiesViewModelImpl.h"
#import "PMLocalitiesResponse.h"
#import "PMLocalityForm.h"
#import "PMLocalityViewModelImpl.h"
#import "PMCustomLocalityResponse.h"
#import "PMLocationContext.h"

NSString * const PMSelectLocalityFilterLogicErrorDomain = @"com.mydreams.SelectLocalityFilter.logic.error";

@interface PMSelectLocalityFilterLogic ()
@property (nonatomic, strong) PMLocationContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSArray *localities;
@property (strong, nonatomic) RACSubject *cancelSignal;

@end

@implementation PMSelectLocalityFilterLogic
@dynamic context;


- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];

    self.searchTerminal = RACChannelTo(self, searchRequest);
    
    @weakify(self);
    
    [[RACObserve(self, searchRequest)
        skip:1]
        subscribeNext:^(id x) {
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

- (void)selectLocalityWithIndex:(NSInteger)index
{
    PMLocality *locality = self.localities[index];
    [self.context.localitySubject sendNext:locality];
    [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectLocalityFilterVC];
}

#pragma mark - private

- (RACSignal *)loadData
{
    @weakify(self);
    return [[[self.locationService localitiesListCountry:self.context.countryIdx searchTerm:self.searchRequest]
        takeUntil:self.cancelSignal]
        doNext:^(PMLocalitiesResponse *response) {
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
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSelectLocalityFilterVC];
        return [RACSignal empty];
    }];
}
@end


