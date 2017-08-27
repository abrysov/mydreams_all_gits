//
//  PMSuccessRemaindPasswordVC.m
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSuccessSendingEmailVC.h"
#import "PMSuccessSendingEmailLogic.h"

@interface PMSuccessSendingEmailVC()
@property (strong, nonatomic) PMSuccessSendingEmailLogic *logic;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *entranceButton;
@property (weak, nonatomic) IBOutlet UIButton *iterationButton;
@property (weak, nonatomic) IBOutlet UILabel *checkSendingLabel;
@end

@implementation PMSuccessSendingEmailVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    RAC(self.emailLabel, text) = RACObserve(self.logic, email);
    self.entranceButton.rac_command = self.logic.doneCommand;
    self.iterationButton.rac_command = self.logic.resendCommand;
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.titleLabel.text = NSLocalizedString(@"auth.success_sending_email.title", nil);
    [self.entranceButton setTitle:[NSLocalizedString(@"auth.success_sending_email.enter", nil) uppercaseString] forState:UIControlStateNormal];
    [self.iterationButton setTitle:[NSLocalizedString(@"auth.success_sending_email.resend_button", nil) uppercaseString] forState:UIControlStateNormal];
    self.checkSendingLabel.text = NSLocalizedString(@"auth.success_sending_email.iteration_description", nil);
}

@end
