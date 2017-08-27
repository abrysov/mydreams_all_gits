//
//  PMChangeEmailLogic.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangeEmailLogic.h"
#import "SettingsSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMEmailValidator.h"
#import "PMDreamerResponse.h"

NSString * const PMChangeEmailLogicErrorDomain = @"com.mydreams.ChangeEmail.logic.error";

@interface PMChangeEmailLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *sendCommand;
@property (nonatomic, strong) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong) RACChannelTerminal *currentEmailTerminal;
@property (nonatomic, strong) NSString *currentEmail;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, assign) BOOL isValidEmail;
@end

@implementation PMChangeEmailLogic

- (void)startLogic
{
    [super startLogic];
    self.emailTerminal = RACChannelTo(self, email);
    self.currentEmailTerminal = RACChannelTo(self,  currentEmail);

    self.backCommand = [self createBackCommand];
    self.sendCommand = [self createSendCommand];
    
    @weakify(self);
    
    [[RACObserve(self, email)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            [self validateEmail];
        }];
}

- (RACSignal *)loadData
{
    return [[self.profileApiClient getMe] doNext:^(PMDreamerResponse *response) {
        self.currentEmail = response.dreamer.email;
    }];
}

#pragma mark - commands

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseChangeEmailVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validateEmail];
        if (self.isValidEmail) {
            return [[self.profileApiClient changeEmail:self.email] doNext:^(id x) {
                [self performSegueWithIdentifier:kPMSegueIdentifierCloseChangeEmailVC];
            }];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMChangeEmailLogicErrorDomain
                                                 code:PMChangeEmailLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"settings.change_email.invalid_email", nil)}];
            return [RACSignal error:error];
        }
    }];
}

#pragma mark - validate

- (void)validateEmail
{
    self.isValidEmail = [self.emailValidator isEmailValid:self.email];
}

@end
