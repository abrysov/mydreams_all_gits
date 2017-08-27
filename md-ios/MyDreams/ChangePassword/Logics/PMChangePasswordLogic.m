//
//  PMChangePasswordLogic.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangePasswordLogic.h"
#import "SettingsSegues.h"
#import "PMBaseLogic+Protected.h"

NSString * const PMChangePasswordLogicErrorDomain = @"com.mydreams.ChangePassword.logic.error";

@interface PMChangePasswordLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *sendCommand;
@property (nonatomic, strong) RACChannelTerminal *currentPasswordTerminal;
@property (nonatomic, strong) RACChannelTerminal *passwordTerminal;
@property (nonatomic, strong) RACChannelTerminal *passwordConfirmationTerminal;
@property (nonatomic, strong) NSString *currentPassword;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *passwordConfirmation;
@property (nonatomic, assign) BOOL isValidCurrentPassword;
@property (nonatomic, assign) BOOL isValidPassword;
@property (nonatomic, assign) BOOL isValidPasswordConfirmation;

@end

@implementation PMChangePasswordLogic

- (void)startLogic
{
    [super startLogic];
    self.currentPasswordTerminal = RACChannelTo(self, currentPassword);
    self.passwordTerminal = RACChannelTo(self, password);
    self.passwordConfirmationTerminal = RACChannelTo(self, passwordConfirmation);
    self.backCommand = [self createBackCommand];
    self.sendCommand = [self createSendCommand];

    @weakify(self);
    
    [[RACObserve(self, currentPassword)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            [self validateCurrentPassword];
        }];
    
    [[RACObserve(self, password)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            [self validatePassword];
            if (self.passwordConfirmation) {
                [self validatePasswordConfirmation];
            }
        }];
    
    [[RACObserve(self, passwordConfirmation)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            [self validatePasswordConfirmation];
        }];
}

#pragma mark - commands

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseChangePasswordVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if ([self isValidInput]) {
            return [[self.profileApiClient changePasswordWithCurrentPassword:self.currentPassword password:self.password passwordConfirmation:self.passwordConfirmation] doNext:^(id x) {
                [self performSegueWithIdentifier:kPMSegueIdentifierCloseChangePasswordVC];
            }];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMChangePasswordLogicErrorDomain
                                                 code:PMChangePasswordLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:[self errorMessage]}];
            return [RACSignal error:error];
        }
    }];
}

#pragma mark - validate

- (void)validateCurrentPassword
{
    NSString *trimmedString = [self.currentPassword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.isValidCurrentPassword = (trimmedString.length > 5) && (trimmedString.length < 255);
}

- (void)validatePassword
{
    NSString *trimmedString = [self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.isValidPassword = (trimmedString.length > 5) && (trimmedString.length < 255);
}

- (void)validatePasswordConfirmation
{
    self.isValidPasswordConfirmation = [self.password isEqualToString:self.passwordConfirmation];
}

- (void)validate
{
    [self validateCurrentPassword];
    [self validatePassword];
    [self validatePasswordConfirmation];
}

- (BOOL)isValidInput
{
    return self.isValidCurrentPassword && self.isValidPassword && self.isValidPasswordConfirmation;
}

#pragma mark - private

- (NSString *)errorMessage
{
    if (!self.isValidCurrentPassword) {
        return NSLocalizedString(@"settings.change_password.invalid_current_password", nil);
    }
    if (!self.isValidPassword) {
        return NSLocalizedString(@"settings.change_password.invalid_new_password", nil);
    }
    if (!self.isValidPasswordConfirmation) {
        return NSLocalizedString(@"settings.change_password.invalid_password_confirmation", nil);
    }
    return NSLocalizedString(@"error.invalidInput", nil);
}
@end
