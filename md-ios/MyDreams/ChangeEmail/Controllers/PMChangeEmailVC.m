//
//  PMChangeEmailVC.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangeEmailVC.h"
#import "PMChangeEmailLogic.h"
#import "CellSettingsView.h"
#import "UITextField+PM.h"

@interface PMChangeEmailVC ()
@property (strong, nonatomic) PMChangeEmailLogic *logic;
@property (weak, nonatomic) IBOutlet CellSettingsView *currentEmailView;
@property (weak, nonatomic) IBOutlet CellSettingsView *emailView;

@property (weak, nonatomic) IBOutlet UILabel *sendDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;

@end

@implementation PMChangeEmailVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.emailView.valueTextField.autocorrectionType = UITextAutocorrectionTypeNo;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    [self.emailView.valueTextField establishChannelToTextWithTerminal:self.logic.emailTerminal];
    [self.currentEmailView.valueTextField establishChannelToTextWithTerminal:self.logic.currentEmailTerminal];
    
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.sendButton.rac_command = self.logic.sendCommand;
    
    @weakify(self);
    [self.sendButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
    }];
    
    RAC(self.emailView, inputState) = [[RACObserve(self.logic, isValidEmail) skip:1]  map:^id(NSNumber *value) {
        return @([value boolValue] ? PMCellSettingsViewInputStateValid: PMCellSettingsViewInputStateInvalid);
    }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.title = [NSLocalizedString(@"settings.change_email.title", nil) uppercaseString];
    self.currentEmailView.titleLabel.text = NSLocalizedString(@"settings.change_email.current_email_description", nil);
    self.emailView.titleLabel.text = NSLocalizedString(@"settings.change_email.email_description", nil);
    self.sendDescriptionLabel.text = NSLocalizedString(@"settings.change_email.send_button_description", nil);
    [self.sendButton setTitle:NSLocalizedString(@"settings.change_email.send_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - private

-(IBAction)prepareForUnwindChangeEmail:(UIStoryboardSegue *)segue {}

@end
