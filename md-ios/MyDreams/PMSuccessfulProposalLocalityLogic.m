//
//  PMAddLocalityLogic.m
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSuccessfulProposalLocalityLogic.h"
#import "PMUserContext.h"
#import "PMBaseLogic+Protected.h"
#import "AuthentificationSegues.h"

NSString * const PMSuccessfulProposalLocalityLogicErrorDomain = @"com.mydreams.AddLocality.logic.error";

@interface PMSuccessfulProposalLocalityLogic ()
@property (nonatomic, weak) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backToRegistrationCommand;
@property (nonatomic, strong) PMCustomLocalityViewModelImpl *customLocality;

@end

@implementation PMSuccessfulProposalLocalityLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    @weakify(self);
    
    self.backToRegistrationCommand = [self createBackToRegistrationCommand];
  
    [RACObserve(self.context.userForm, customLocality) subscribeNext:^(PMLocalityForm *localityForm) {
        @strongify(self);
        self.customLocality = [[PMCustomLocalityViewModelImpl alloc] initWithLocalityForm:localityForm];
    }];
}

- (RACCommand *)createBackToRegistrationCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSuccessfulProposalLocalityVCInRegistrationStep3VC context:self.context];
        return [RACSignal empty];
    }];
}

#pragma mark - private

@end
