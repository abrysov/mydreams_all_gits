//
//  PMRegistrationLogic.m
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationLogic.h"
#import "PMRegistrationViewModelImpl.h"
#import "AuthentificationSegues.h"
#import "PMBaseLogic+Protected.h"
#import "PMUserContext.h"
#import "PMDreamerResponse.h"
#import "PMEmailValidator.h"
#import "PMSocketClient.h"

@interface PMRegistrationLogic ()
@property (nonatomic, strong) PMUserContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *nextStepCommand;

@property (nonatomic, strong) PMRegistrationViewModelImpl *viewModel;

@property (nonatomic, strong) RACCommand *loginWithVKCommand;
@property (nonatomic, strong) RACCommand *loginWithFacebookCommand;
@property (nonatomic, strong) RACCommand *loginWithInstagrammCommand;
@property (nonatomic, strong) RACCommand *loginWithTwitterCommand;

@property (nonatomic, strong) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong) RACChannelTerminal *passwordTerminal;
@property (nonatomic, strong) RACChannelTerminal *confirmPasswordTerminal;
@end

@implementation PMRegistrationLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];
    
    PMUserForm *userForm = [[PMUserForm alloc] initWithEmailValidator:self.emailValidator];
    self.context = [PMUserContext contextWithUserForm:userForm];
    self.viewModel = [[PMRegistrationViewModelImpl alloc] initWithUserForm:userForm];
    
    self.backCommand = [self createBackCommand];
    self.nextStepCommand = [self createNextStepCommand];
    
    self.loginWithVKCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkVK];
    self.loginWithFacebookCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkFacebook];
    self.loginWithInstagrammCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkInstagram];
    self.loginWithTwitterCommand = [self commandForSocialNetwork:PMAuthServiceSocialNetworkTwitter];
    
    RAC(self, viewModel) = [[[RACObserve(self, context)
        ignore:nil]
        distinctUntilChanged]
        map:^id<PMRegistrationViewModel>(PMUserContext *context) {
            return [[PMRegistrationViewModelImpl alloc] initWithUserForm:context.userForm];
        }];
    
    self.emailTerminal = RACChannelTo(self.context, userForm.email);
    self.passwordTerminal = RACChannelTo(self.context, userForm.password);
    self.confirmPasswordTerminal = RACChannelTo(self.context, userForm.confirmPassword);
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseRegistrationVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createNextStepCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if (self.isValidInput) {
            [self performSegueWithIdentifier:kPMSegueIdentifierToRegistrationStep2VC context:self.context];
        }
        return [RACSignal empty];
    }];
}

- (RACCommand *)commandForSocialNetwork:(PMAuthServiceSocialNetwork) socialNetwork
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(PMSocialNetworkCredentials *credentials) {
        @strongify(self);
        return [self authenticateWithSocialNetwork:socialNetwork credentials:credentials];
    }];
}

#pragma mark - private

- (RACSignal *)connectSocketAndOpenVCOn:(RACSignal *)signal
{
    @weakify(self);
    return [signal
        doNext:^(PMDreamerResponse *response) {
            @strongify(self);
            [self.socketClient openSocketWithToken:response.dreamer.token];
            [self.router openMainVC];
        }];
}

- (RACSignal *)authenticateWithSocialNetwork:(PMAuthServiceSocialNetwork) socialNetwork credentials:(PMSocialNetworkCredentials *)credentials
{
    return [self connectSocketAndOpenVCOn:[self.authService authenticateWithSocialNetwork:socialNetwork credentials:credentials]];
}

#pragma mark - validation

- (void)validate
{
    [self.emailValidator isEmailValid:self.context.userForm.email];
    [self.context.userForm validatePassword];
    [self.context.userForm validateConfirmPassword];
}

- (BOOL)isValidInput
{
    return self.context.userForm.isValidEmail && self.context.userForm.isValidPassword && self.context.userForm.isValidConfirmPassword;
}

@end
