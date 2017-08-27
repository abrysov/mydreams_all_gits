//
//  PMRegistrationStep3VC.m
//  MyDreams
//
//  Created by user on 17.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep3VC.h"
#import "PMRegistrationStep3Logic.h"
#import "PMCellFillView.h"
#import "UITextField+PM.h"
#import "PMImageForm.h"
#import "UIView+PM.h"
#import "PMImageSelector.h"

@interface PMRegistrationStep3VC () <PMImageSelectorDelegate>
@property (strong, nonatomic) PMRegistrationStep3Logic *logic;
@property (weak, nonatomic) IBOutlet PMCellFillView *phoneNumberView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *onePageButton;
@property (weak, nonatomic) IBOutlet UIButton *twoPageButton;
@property (weak, nonatomic) IBOutlet UIButton *threePageButton;
@property (weak, nonatomic) IBOutlet UIButton *completeButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoIcon;
@property (weak, nonatomic) IBOutlet UILabel *topDescriptionSendLabel;
@property (weak, nonatomic) IBOutlet UILabel *botDescriptionSendLabel;
@property (weak, nonatomic) IBOutlet UIButton *userAgreementButton;
@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMRegistrationStep3VC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
 
    self.phoneNumberView.valueTextField.keyboardType = UIKeyboardTypePhonePad;
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:YES resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    self.backButton.rac_command = self.logic.backCommand;
    self.locationButton.rac_command = self.logic.showSelectionLocationCommand;
    self.completeButton.rac_command = self.logic.completeRegistrationCommand;
    self.userAgreementButton.rac_command = self.logic.toUserAgreementCommand;
    [self.phoneNumberView.valueTextField establishChannelToTextWithTerminal:self.logic.phoneNumberTerminal];
    RAC(self.locationLabel, text) = RACObserve(self.logic, viewModel.locationTitle);
    
    @weakify(self);
    [self.logic.completeRegistrationCommand.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
    }];
    
    RAC(self.phoneNumberView, inputState) = [[RACObserve(self.logic, viewModel.isValidPhoneNumber)
        skip:1]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];
    
    [RACObserve(self.logic, viewModel.avatar)
        subscribeNext:^(UIImage *avatar) {
            @strongify(self);
            if (avatar) {
                self.photoImageView.image = avatar;
                self.photoImageView.cornerRadius = self.photoImageView.frame.size.width / 2;
                self.addPhotoIcon.hidden = NO;
            }
        }];
    
    [[RACObserve(self.logic, viewModel.errorsSubject)
        switchToLatest]
        subscribeNext:^(NSString *errorText) {
            @strongify(self);
            [self showToastViewWithTitle:errorText buttonCommand:nil];
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];

    self.titleLabel.text = [NSLocalizedString(@"auth.registation_step_3.title", nil) uppercaseString];
    self.descriptionLocationLabel.text =  NSLocalizedString(@"auth.registation_step_3.location_description", nil);
    [self.phoneNumberView.titleButton setTitle:NSLocalizedString(@"auth.registation_step_3.phone_number_description", nil) forState:UIControlStateNormal];
    [self.completeButton setTitle:[NSLocalizedString(@"auth.registation_step_3.send_button_title", nil) uppercaseString] forState:UIControlStateNormal];
    self.topDescriptionSendLabel.text = NSLocalizedString(@"auth.registation_step_3.top_description_send_button", nil);
    self.botDescriptionSendLabel.text = NSLocalizedString(@"auth.registation_step_3.bot_description_send_button", nil);
    [self.userAgreementButton setTitle:NSLocalizedString(@"auth.registation_step_3.user_agreement_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - actions

-(IBAction)prepareForUnwindRegistrationStep3:(UIStoryboardSegue *)segue {}

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    PMImageForm *avatar = [[PMImageForm alloc] initWithImage:image croppedImage:croppedImage rect:cropRect];
    [self.logic setAvatarForm:avatar];
}

@end
