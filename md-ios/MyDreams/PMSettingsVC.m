//
//  PMSettingsVC.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSettingsVC.h"
#import "PMSettingsLogic.h"

@interface PMSettingsVC ()
@property (strong, nonatomic) PMSettingsLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *toChangePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *toChangeEmailButton;
@property (weak, nonatomic) IBOutlet UIButton *toEditProfileButton;
@property (weak, nonatomic) IBOutlet UIButton *accountDeletingButton;
@end

@implementation PMSettingsVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.signOutButton.rac_command = self.logic.signOutCommand;
    self.toChangePasswordButton.rac_command = self.logic.toChangePasswordCommand;
    self.toChangeEmailButton.rac_command = self.logic.toChangeEmailCommand;
    self.toEditProfileButton.rac_command = self.logic.toEditProfileCommand;
}

- (void)setupLocalization
{
    [super setupLocalization];
    [self.toChangePasswordButton setTitle:[NSLocalizedString(@"settings.settings.change_password", nil) uppercaseString] forState:UIControlStateNormal];
    [self.toChangeEmailButton setTitle:[NSLocalizedString(@"settings.settings.change_email", nil) uppercaseString] forState:UIControlStateNormal];
    [self.toEditProfileButton setTitle:[NSLocalizedString(@"settings.settings.edit_profile", nil) uppercaseString] forState:UIControlStateNormal];
    [self.accountDeletingButton setTitle:[NSLocalizedString(@"settings.settings.account_deleting", nil) uppercaseString] forState:UIControlStateNormal];
    [self.signOutButton setTitle:[NSLocalizedString(@"settings.settings.self.sign_out", nil) uppercaseString] forState:UIControlStateNormal];
    self.title = [NSLocalizedString(@"settings.settings.title", nil) uppercaseString];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - actions

- (IBAction)showAlertBeforeAccountDeleting:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"settings.settings.account_deleting", nil)
                                                                   message:NSLocalizedString(@"settings.settings.account_deleting_description", nil)
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_manager.OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action) {
                                                         [self.logic.accountDeletingCommand execute:nil];
                                                     }];
    [alert addAction:okButton];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_manager.Cancel", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
