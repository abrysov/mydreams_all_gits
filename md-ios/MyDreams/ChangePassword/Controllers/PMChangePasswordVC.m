//
//  PMChangePasswordVC.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangePasswordVC.h"
#import "PMChangePasswordLogic.h"
#import "CellSettingsView.h"
#import "UITextField+PM.h"

@interface PMChangePasswordVC ()
@property (strong, nonatomic) PMChangePasswordLogic *logic;
@property (weak, nonatomic) IBOutlet CellSettingsView *currentPasswordView;
@property (weak, nonatomic) IBOutlet CellSettingsView *passwordView;
@property (weak, nonatomic) IBOutlet CellSettingsView *passwordConfirmationView;
@property (weak, nonatomic) IBOutlet UILabel *sendDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@end

@implementation PMChangePasswordVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    [self.currentPasswordView.valueTextField establishChannelToTextWithTerminal:self.logic.currentPasswordTerminal];
    [self.passwordView.valueTextField establishChannelToTextWithTerminal:self.logic.passwordTerminal];
    [self.passwordConfirmationView.valueTextField establishChannelToTextWithTerminal:self.logic.passwordConfirmationTerminal];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.sendButton.rac_command = self.logic.sendCommand;
   
    @weakify(self);
    [self.sendButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
    }];
    
    RAC(self.passwordConfirmationView, inputState) = [[RACObserve(self.logic, isValidPasswordConfirmation) skip:1]  map:^id(NSNumber *value) {
        return @([value boolValue] ? PMCellSettingsViewInputStateValid: PMCellSettingsViewInputStateInvalid);
    }];
    
    RAC(self.currentPasswordView, inputState) = [[RACObserve(self.logic, isValidCurrentPassword) skip:1] map:^id(NSNumber *value) {
        return @([value boolValue] ? PMCellSettingsViewInputStateValid: PMCellSettingsViewInputStateInvalid);
    }];
    
    RAC(self.passwordView, inputState) = [[RACObserve(self.logic, isValidPassword) skip:1]  map:^id(NSNumber *value) {
        return @([value boolValue] ? PMCellSettingsViewInputStateValid: PMCellSettingsViewInputStateInvalid);
    }];
}

- (void)setupUI
{
    [super setupUI];
    self.currentPasswordView.valueTextField.secureTextEntry = YES;
    self.passwordView.valueTextField.secureTextEntry = YES;
    self.passwordConfirmationView.valueTextField.secureTextEntry = YES;
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.title = [NSLocalizedString(@"settings.change_password.title", nil) uppercaseString];
    self.currentPasswordView.titleLabel.text = NSLocalizedString(@"settings.change_password.old_password_description", nil);
    self.passwordView.titleLabel.text = NSLocalizedString(@"settings.change_password.new_password_description", nil);
    self.passwordConfirmationView.titleLabel.text = NSLocalizedString(@"settings.change_password.password_confirmation_description", nil);
    self.sendDescriptionLabel.text = NSLocalizedString(@"settings.change_password.send_button_description", nil);
    [self.sendButton setTitle:NSLocalizedString(@"settings.change_password.send_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - private

-(IBAction)prepareForUnwindChangePassword:(UIStoryboardSegue *)segue {}

@end
