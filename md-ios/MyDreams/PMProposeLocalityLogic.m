//
//  PMSentenceLocalityLogic.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMProposeLocalityLogic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMLocalityForm.h"
#import "PMCustomLocalityResponse.h"
#import "PMUserContext.h"

NSString * const PMProposeLocalityLogicErrorDomain = @"com.mydreams.SelectLocality.logic.error";

@interface PMProposeLocalityLogic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *sendLocalityCommand;
@property (nonatomic, strong) RACChannelTerminal *searchTerminal;
@property (nonatomic, strong) RACChannelTerminal *regionTerminal;
@property (nonatomic, strong) RACChannelTerminal *destrictTerminal;
@property (nonatomic, strong) NSString *searchRequest;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *district;
@end

@implementation PMProposeLocalityLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
    self.sendLocalityCommand = [self createSendLocalityCommand];
    self.searchTerminal = RACChannelTo(self, searchRequest);
    self.regionTerminal = RACChannelTo(self, region);
    self.destrictTerminal = RACChannelTo(self, district);
}

#pragma mark - private

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseProposeLocalityVC context:self.context];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendLocalityCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        if ([self isCustomLocality]) {
            self.context.userForm.customLocality = [[PMLocalityForm alloc] init];
            self.context.userForm.customLocality.name = self.searchRequest;
            self.context.userForm.customLocality.region = self.region;
            self.context.userForm.customLocality.district = self.district;
            [[self.locationService createLocalityInfo:self.context.userForm.customLocality inCountry:self.context.userForm.country.idx] subscribeNext:^(PMCustomLocalityResponse *response) {
                @strongify(self);
                self.context.userForm.locality = response.locality;
                [self performSegueWithIdentifier:kPMSegueIdentifierToSuccessfulProposalLocalityVC context:self.context];
            }];
        }
        return [RACSignal empty];
    }];
}

- (BOOL)isCustomLocality
{
    if (self.searchRequest.length != 0) {
        return YES;
    }
    return NO;
}

@end
