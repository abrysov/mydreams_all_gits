//
//  PMAuthorizationVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAuthorizationVC.h"
#import "PMAuthorizationLogic.h"
#import "UITextField+PM.h"
#import "PMTextField.h"
#import "PMSocialAuthButton.h"
#import "PMSocialAuthFactory.h"
#import "PMAlertManager.h"

@interface PMAuthorizationVC ()
@property (strong, nonatomic) PMAuthorizationLogic *logic;
@property (weak, nonatomic) IBOutlet PMTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet PMTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *remaindPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *vkButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *facebookButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *instagrammButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (strong, nonatomic) NSDictionary *socialCommands;
@end

@implementation PMAuthorizationVC
@synthesize logic;

- (void)setupUI
{
    [super setupUI];
    
    self.vkButton.provider = PMSocialAuthFactoryVK;
    self.facebookButton.provider = PMSocialAuthFactoryFacebook;
    self.instagrammButton.provider = PMSocialAuthFactoryInstagram;
    self.twitterButton.provider = PMSocialAuthFactoryTwitter;
    
    self.usernameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)bindUIWithLogics
{
    self.socialCommands = @{PMSocialAuthFactoryFacebook: self.logic.loginWithFacebookCommand,
                            PMSocialAuthFactoryInstagram: self.logic.loginWithInstagrammCommand,
                            PMSocialAuthFactoryTwitter: self.logic.loginWithTwitterCommand,
                            PMSocialAuthFactoryVK: self.logic.loginWithVKCommand,
                            };
    
    [super bindUIWithLogics];
    
    [self.usernameTextField establishChannelToTextWithTerminal:self.logic.usernameTerminal];
    [self.passwordTextField establishChannelToTextWithTerminal:self.logic.passwordTerminal];
    
    self.remaindPasswordButton.rac_command = self.logic.remaindPasswordCommand;
    self.loginButton.rac_command = self.logic.loginCommand;
    self.registrationButton.rac_command = self.logic.registrationCommand;
    
    RAC(self.usernameTextField, inputState) = [[RACObserve(self.logic, isValidUsername)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMTextFieldInputStateValid : PMTextFieldInputStateInvalid);
        }];
    
    RAC(self.passwordTextField, inputState) = [[RACObserve(self.logic, isValidPassword)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMTextFieldInputStateValid : PMTextFieldInputStateInvalid);
        }];
    
    [self interceptionSocialAuthError];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.usernameTextField.placeholder = NSLocalizedString(@"auth.auth_vc.email_placeholder", nil);
    self.passwordTextField.placeholder = NSLocalizedString(@"auth.auth_vc.password_placeholder", nil);
    [self.remaindPasswordButton setTitle:[NSLocalizedString(@"auth.auth_vc.remaind_password", nil) uppercaseString] forState:UIControlStateNormal];
    [self.loginButton setTitle:[NSLocalizedString(@"auth.auth_vc.sign_in", nil) uppercaseString] forState:UIControlStateNormal];
    [self.registrationButton setTitle:[NSLocalizedString(@"auth.auth_vc.sign_up", nil) uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)socialAuth:(PMSocialAuthButton *)button
{
    @weakify(self);
    id<PMSocialNetworkAuth> auth = [self.socialAuthFactory socialNetwork:button.provider];
    [[auth authWithController:self]
        subscribeNext:^(id credentials) {
            @strongify(self);
            [self.socialCommands[button.provider] execute:credentials];
        }];
}

#pragma mark - private

- (void)interceptionSocialAuthError
{
    NSArray<RACCommand *> *socialCommands = self.socialCommands.allValues;
    for (RACCommand *command in socialCommands) {
        [self.alertManager processErrorsOfCommand:command in:self];
    }
}

//TODO: temprory work around for unwind from success email sended screen to auth screen
-(IBAction)prepareForUnwindAuthorization:(UIStoryboardSegue *)segue {}

@end
