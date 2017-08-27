//
//  PMUserAgreementLogic.m
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserAgreementLogic.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMAuthService.h"
#import "PMUserAgreementResponse.h"

NSString * const PMUserAgreementLogicErrorDomain = @"com.mydreams.SelectLocality.logic.error";

@interface PMUserAgreementLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) PMUserAgreementViewModelImpl *viewModel;
@end

@implementation PMUserAgreementLogic

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseUserAgreement];
        return [RACSignal empty];
    }];
}

- (RACSignal *)loadData
{
    @weakify(self);
    return [[self.authService userAgreement] doNext:^(PMUserAgreementResponse *response) {
        @strongify(self);
        self.viewModel = [[PMUserAgreementViewModelImpl alloc] initWithUserAgreement:response.terms];
    }];
}

@end
