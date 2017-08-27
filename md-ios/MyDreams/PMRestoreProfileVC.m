//
//  PMRestoreProfileVC.m
//  MyDreams
//
//  Created by user on 14.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRestoreProfileVC.h"
#import "PMRestoreProfileLogic.h"
#import "PMTextField.h"
#import "UITextField+PM.h"
#import "PMAlertManager.h"

@interface PMRestoreProfileVC ()
@property (strong, nonatomic) PMRestoreProfileLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendEmailButtonDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendEmailButton;
@end

@implementation PMRestoreProfileVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    self.backButton.rac_command = self.logic.backCommand;
    self.sendEmailButton.rac_command = self.logic.sendEmailCommand;
    
    [self.alertManager processErrorsOfCommand:self.sendEmailButton.rac_command in:self];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.titleLabel.text = NSLocalizedString(@"auth.restore_profile.title", nil) ;
    self.topTitleLabel.text = [NSLocalizedString(@"auth.restore_profile.top_title", nil) uppercaseString];
    self.sendEmailButtonDescriptionLabel.text = NSLocalizedString(@"auth.restore_profile.send_button_description", nil);
    [self.sendEmailButton setTitle:NSLocalizedString(@"auth.restore_profile.send_button_title", nil) forState:UIControlStateNormal];
}

@end
