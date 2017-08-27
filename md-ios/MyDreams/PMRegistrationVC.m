//
//  PMRegistrationVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationVC.h"
#import "PMRegistrationLogic.h"
#import "PMCellFillView.h"
#import "UITextField+PM.h"
#import "PMSocialAuthButton.h"

@interface PMRegistrationVC ()
@property (strong, nonatomic) PMRegistrationLogic *logic;
@property (weak, nonatomic) IBOutlet PMCellFillView *emailView;
@property (weak, nonatomic) IBOutlet PMCellFillView *passwordView;
@property (weak, nonatomic) IBOutlet PMCellFillView *confirmPasswordView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *vkButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *facebookButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *instagramButton;
@property (weak, nonatomic) IBOutlet PMSocialAuthButton *twitterButton;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *pageOneButton;
@property (weak, nonatomic) IBOutlet UIButton *pageTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *pageThreeButton;
@property (strong, nonatomic) NSDictionary *socialCommands;
@end

@implementation PMRegistrationVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.emailView.valueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    self.socialCommands = @{PMSocialAuthFactoryFacebook: self.logic.loginWithFacebookCommand,
                            PMSocialAuthFactoryInstagram: self.logic.loginWithInstagrammCommand,
                            PMSocialAuthFactoryTwitter: self.logic.loginWithTwitterCommand,
                            PMSocialAuthFactoryVK: self.logic.loginWithVKCommand,
                            };
    
    [self.emailView.valueTextField establishChannelToTextWithTerminal:self.logic.emailTerminal];
    [self.passwordView.valueTextField establishChannelToTextWithTerminal:self.logic.passwordTerminal];
    [self.confirmPasswordView.valueTextField establishChannelToTextWithTerminal:self.logic.confirmPasswordTerminal];
    self.backButton.rac_command = self.logic.backCommand;
    self.nextButton.rac_command = self.logic.nextStepCommand;
    self.passwordView.valueTextField.secureTextEntry = YES;
    self.confirmPasswordView.valueTextField.secureTextEntry = YES;
    
    
    self.vkButton.provider = PMSocialAuthFactoryVK;
    self.facebookButton.provider = PMSocialAuthFactoryFacebook;
    self.instagramButton.provider = PMSocialAuthFactoryInstagram;
    self.twitterButton.provider = PMSocialAuthFactoryTwitter;
    
    RAC(self.emailView, inputState) = [[RACObserve(self.logic, viewModel.isValidEmail)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];
    
    RAC(self.passwordView, inputState) = [[RACObserve(self.logic, viewModel.isValidPassword)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
           BOOL isValidBool = [isValid boolValue];
           return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];

    RAC(self.confirmPasswordView, inputState) = [[RACObserve(self.logic, viewModel.isValidConfirmPassword)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
           BOOL isValidBool = [isValid boolValue];
           return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.titleLabel.text = [NSLocalizedString(@"auth.registation.title", nil) uppercaseString];
    [self.emailView.titleButton setTitle:NSLocalizedString(@"auth.registation.email_description", nil) forState:UIControlStateNormal];
    [self.emailView.titleButton setImage:[UIImage imageNamed:@"email_button_icon.png"] forState:UIControlStateNormal];
    [self.passwordView.titleButton setImage:[UIImage imageNamed:@"password_registration_icon.png"] forState:UIControlStateNormal];
    [self.confirmPasswordView.titleButton setImage:[UIImage imageNamed:@"password_registration_icon.png"] forState:UIControlStateNormal];
    [self.passwordView.titleButton setTitle:NSLocalizedString(@"auth.registation.password_description", nil)forState:UIControlStateNormal];
    [self.confirmPasswordView.titleButton setTitle:NSLocalizedString(@"auth.registation.confirm_password_description", nil) forState:UIControlStateNormal];
    self.orLabel.text = [NSLocalizedString(@"auth.registation.or", nil) lowercaseString];
    [self.nextButton setTitle:[NSLocalizedString(@"auth.registation.next_button_title", nil)uppercaseString] forState:UIControlStateNormal];
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

@end
