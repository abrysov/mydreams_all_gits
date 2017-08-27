//
//  PMRemaindPasswordVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRemaindPasswordVC.h"
#import "PMRemaindPasswordLogic.h"
#import "UITextField+PM.h"
#import "PMTextField.h"
#import "PMAlertManager.h"

@interface PMRemaindPasswordVC ()
@property (strong, nonatomic) PMRemaindPasswordLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailTextFieldDescriptionLabel;
@property (weak, nonatomic) IBOutlet PMTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UILabel *sendEmailButtonDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@end

@implementation PMRemaindPasswordVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.emailTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    [self.emailTextField establishChannelToTextWithTerminal:self.logic.emailTerminal];
    
    RAC(self.emailTextField, inputState) = [[RACObserve(self.logic, isValidEmail)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMTextFieldInputStateValid : PMTextFieldInputStateInvalid);
        }];
    
    self.backButton.rac_command = self.logic.backCommand;
    self.sendEmailButton.rac_command = self.logic.sendEmailCommand;
    
    [self.alertManager processErrorsOfCommand:self.sendEmailButton.rac_command in:self];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.titleLabel.text = [NSLocalizedString(@"auth.remaind_password.title", nil) uppercaseString];
    self.emailTextFieldDescriptionLabel.text = NSLocalizedString(@"auth.remaind_password.email_description", nil);
    self.sendEmailButtonDescriptionLabel.text = NSLocalizedString(@"auth.remaind_password.send_button_description", nil);
    self.emailTextField.placeholder = NSLocalizedString(@"auth.remaind_password.email_placehodler", nil);
    [self.sendEmailButton setTitle:NSLocalizedString(@"auth.remaind_password.send_button_title", nil) forState:UIControlStateNormal];
}

@end
