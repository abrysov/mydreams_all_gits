//
//  PMBlockedProfileVC.m
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBlockedProfileVC.h"
#import "PMBlockedProfileLogic.h"

@interface PMBlockedProfileVC ()
@property (strong, nonatomic) PMBlockedProfileLogic *logic;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *profileBlockedLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *openEmailButton;
@end

@implementation PMBlockedProfileVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];

    [self.openEmailButton setTitle:[self.logic.supportEmail lowercaseString] forState:UIControlStateNormal];
    self.backButton.rac_command = self.logic.backCommand;
    self.openEmailButton.rac_command = self.logic.openEmailCommand;
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.profileBlockedLabel.text = NSLocalizedString(@"auth.blocked_profile.title", nil);
    self.supportDescriptionLabel.text = NSLocalizedString(@"auth.blocked_profile.contact_support_description", nil);
}

@end
