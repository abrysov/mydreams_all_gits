//
//  PMUserAgreementVC.m
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserAgreementVC.h"
#import "PMUserAgreementLogic.h"
#import "PMAlertManager.h"
#import "UIColor+MyDreams.h"

@interface PMUserAgreementVC ()
@property (strong, nonatomic) PMUserAgreementLogic *logic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userAgreementContentLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PMUserAgreementVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.isStateViewTransparent = YES;
    self.stateViewTextColor = [UIColor userAgreementColor];
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backButton.rac_command = self.logic.backCommand;
   
    RAC(self.userAgreementContentLabel,attributedText) = [RACObserve(self.logic, viewModel.userAgreement) deliverOn:[RACScheduler mainThreadScheduler]];
    
    [self.alertManager processErrorsOfCommand:self.logic.loadDataCommand in:self];
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.titleLabel.text = [NSLocalizedString(@"auth.user_agreement.title", nil) uppercaseString];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.scrollView;
}

#pragma mark - private

- (IBAction)prepareForUnwindSelectLocality:(UIStoryboardSegue *)segue {}

@end
