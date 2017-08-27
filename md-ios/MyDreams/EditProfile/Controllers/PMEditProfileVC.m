//
//  PMEditProfileVC.m
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditProfileVC.h"
#import "PMEditProfileLogic.h"
#import "CellSettingsView.h"
#import "PMSegmentControl.h"
#import "PMSettingsSwitchButtonView.h"
#import "UITextField+PM.h"
#import "PMImageSelector.h"
#import "UIColor+MyDreams.h"

typedef NS_ENUM(NSUInteger, PMIndexSegmentType) {
    PMIndexSegmentTypeFemale,
    PMIndexSegmentTypeMale
};

CGFloat const PMSpacingSegmentControl = 10.0f;

@interface PMEditProfileVC () <PMSegmentControlDelegate, PMImageSelectorDelegate>
@property (strong, nonatomic) PMEditProfileLogic *logic;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet CellSettingsView *firstNameView;
@property (weak, nonatomic) IBOutlet CellSettingsView *secondNameView;

@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeBirthdayButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;
@property (weak, nonatomic) IBOutlet UIView *selectBirthdayView;

@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UIView *genderSegmentControlView;
@property (weak, nonatomic) PMSegmentControl *genderSegmentControl;

@property (weak, nonatomic) IBOutlet UILabel *countryLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCountryButton;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCityButton;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMEditProfileVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.sendButton.rac_command = self.logic.sendCommand;
    self.selectCountryButton.rac_command = self.logic.toSelectCountryCommand;
    self.selectCityButton.rac_command = self.logic.toSelectLocalityCommand;
    
    [self.firstNameView.valueTextField establishChannelToTextWithTerminal:self.logic.firstNameTerminal];
    [self.secondNameView.valueTextField establishChannelToTextWithTerminal:self.logic.secondNameTerminal];
    
    @weakify(self);
    
    [self.sendButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
    }];
    
    
    RAC(self.firstNameView, inputState) = [[[RACObserve(self.logic, viewModel.isValidFirstName)
        skip:1]
        distinctUntilChanged]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellSettingsViewInputStateValid : PMCellSettingsViewInputStateInvalid);
        }];
    
    RAC(self.secondNameView, inputState) = [[[RACObserve(self.logic, viewModel.isValidSecondName)
        skip:1]
        distinctUntilChanged]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellSettingsViewInputStateValid : PMCellSettingsViewInputStateInvalid);
        }];
    
    [[RACObserve(self.logic, viewModel.avatar) ignore:nil]
        subscribeNext:^(UIImage *avatar) {
            @strongify(self);
            self.photoImageView.image = avatar;
        }];
    
    [[RACObserve(self.logic, viewModel.country) ignore:nil]
        subscribeNext:^(NSString *value) {
            @strongify(self);
            self.countryValueLabel.text = value;
        }];
    
    [RACObserve(self.logic, viewModel.locality)
     subscribeNext:^(NSString *value) {
         @strongify(self);
         self.cityValueLabel.text = (value) ? value : NSLocalizedString(@"settings.edit_profile.city_valiue_placeholder", nil);
     }];
    
    [[RACObserve(self.logic, viewModel.birthday) ignore:nil]
        subscribeNext:^(NSDate *birthday) {
            @strongify(self);
            self.birthdayDatePicker.date = birthday;
            self.dayLabel.text = self.logic.viewModel.dayBirthday;
            self.monthLabel.text = self.logic.viewModel.monthBirthday;
            self.yearLabel.text = self.logic.viewModel.yearBirthday;
        }];
    
    [RACObserve(self.logic, viewModel.gender) subscribeNext:^(NSNumber *genderNumber) {
        PMDreamerGender gender = [genderNumber intValue];
        switch (gender) {
            case PMDreamerGenderFemale:
                [self.genderSegmentControl changeSegmentOn:PMIndexSegmentTypeFemale];
                break;
            case PMDreamerGenderMale:
                [self.genderSegmentControl changeSegmentOn:PMIndexSegmentTypeMale];
                break;
            default:
                break;
        }
    }];
}

- (void)setupUI
{
    [super setupUI];
    
    PMSegmentControl *segmentControl = [[PMSegmentControl alloc] initWithItems: @[NSLocalizedString(@"settings.edit_profile.gender_woman", nil),
                                                                                  NSLocalizedString(@"settings.edit_profile.gender_man", nil),]
                                                               bottomLineColor:nil
                                                                         class:[PMSettingsSwitchButtonView class]];
    segmentControl.spacing = PMSpacingSegmentControl;
    
    [self.genderSegmentControlView addSubview:segmentControl];
    
    [segmentControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.genderSegmentControlView);
    }];
    segmentControl.delegate = self;
    
    self.genderSegmentControl = segmentControl;
    
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:YES resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"settings.edit_profile.title", nil) uppercaseString];
    self.firstNameView.titleLabel.text = [NSLocalizedString(@"settings.edit_profile.first_name_description", nil) uppercaseString];
    self.secondNameView.titleLabel.text = [NSLocalizedString(@"settings.edit_profile.second_name_description", nil) uppercaseString];
    self.birthdayLabel.text =  [NSLocalizedString(@"settings.edit_profile.birthday_description", nil) uppercaseString];
    self.dayLabel.text = NSLocalizedString(@"settings.edit_profile.day", nil);
    self.monthLabel.text = NSLocalizedString(@"settings.edit_profile.month", nil);
    self.yearLabel.text = NSLocalizedString(@"settings.edit_profile.year", nil);
    self.genderLabel.text = [NSLocalizedString(@"settings.edit_profile.gender_description", nil) uppercaseString];
    self.countryLabel.text = [NSLocalizedString(@"settings.edit_profile.country_description", nil) uppercaseString];
    self.countryValueLabel.text = NSLocalizedString(@"settings.edit_profile.country_value_placeholder", nil);
    self.cityLabel.text = [NSLocalizedString(@"settings.edit_profile.city_description", nil) uppercaseString];
    self.cityValueLabel.text = NSLocalizedString(@"settings.edit_profile.city_valiue_placeholder", nil);
    [self.sendButton setTitle:NSLocalizedString(@"settings.edit_profile.send_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [UIApplication sharedApplication].statusBarStyle;
}

#pragma mark - actions

- (IBAction)sendBirthday:(id)sender
{
    [self.logic.setBirthdayCommand execute:self.birthdayDatePicker.date];
    self.selectBirthdayView.hidden = YES;
}

- (IBAction)showSelectBirthdayView:(id)sender
{
    self.selectBirthdayView.hidden = NO;
}

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)touchUpSenderColor:(UIButton *)sender
{
    sender.backgroundColor = [UIColor clearColor];
}

- (IBAction)touchDownSenderColor:(UIButton *)sender
{
    sender.backgroundColor = [UIColor dreambookTableViewCellSelectionColor];
}

#pragma mark - private

-(IBAction)prepareForUnwindEditProfile:(UIStoryboardSegue *)segue {}

#pragma mark - PMSegmentControlDelegate

- (void)SegmentControl:(PMSegmentControl *)segmentControl SwitchedOn:(NSInteger)index
{
    switch (index) {
        case PMIndexSegmentTypeFemale:
            [self.logic.selectGenderCommand execute:@(PMDreamerGenderFemale)];
            break;
        case PMIndexSegmentTypeMale:
            [self.logic.selectGenderCommand execute:@(PMDreamerGenderMale)];
            break;
        default:
            [self.logic.selectGenderCommand execute:@(PMDreamerGenderUnknow)];
            break;
    }
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    [self.logic setAvatar:croppedImage];
}

@end
