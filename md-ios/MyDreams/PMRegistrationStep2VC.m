//
//  PMRegistrationStep2.m
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep2VC.h"
#import "PMRegistrationStep2Logic.h"
#import "PMCellFillView.h"
#import "PMSexView.h"
#import "UITextField+PM.h"
#import <UIGestureRecognizer_ReactiveCocoa/UIGestureRecognizer+ReactiveCocoa.h>
#import "UIColor+MyDreams.h"

@interface PMRegistrationStep2VC ()
@property (strong, nonatomic) PMRegistrationStep2Logic *logic;
@property (weak, nonatomic) IBOutlet PMCellFillView *firstNameView;
@property (weak, nonatomic) IBOutlet PMCellFillView *secondNameView;
@property (weak, nonatomic) IBOutlet PMSexView *girlView;
@property (weak, nonatomic) IBOutlet PMSexView *boyView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *birthdayDatePicker;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UILabel *birthdayDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *onePageButton;
@property (weak, nonatomic) IBOutlet UIButton *twoPageButton;
@property (weak, nonatomic) IBOutlet UIButton *threePageButton;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *dateInputViewSeparators;

@end

@implementation PMRegistrationStep2VC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    @weakify(self);
    
    UITapGestureRecognizer *recognizer = [UITapGestureRecognizer rac_recognizer];
    [self.dateView addGestureRecognizer:recognizer];
    [[recognizer rac_signal] subscribeNext:^(UITapGestureRecognizer *sender) {
        @strongify(self);
        self.datePickerView.hidden = NO;
    }];
    
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    self.backButton.rac_command = self.logic.backCommand;
    self.nextButton.rac_command = self.logic.nextStepCommand;
    self.boyView.titleButton.rac_command = self.logic.selectedMaleCommand;
    self.girlView.titleButton.rac_command = self.logic.selectedFemaleCommand;
    self.acceptButton.rac_command = self.logic.receiveBirthDayCommand;
 
    [self.firstNameView.valueTextField establishChannelToTextWithTerminal:self.logic.firstNameTerminal];
    [self.secondNameView.valueTextField establishChannelToTextWithTerminal:self.logic.secondNameTerminal];
    
    RACSignal *genderSignal = RACObserve(self.logic, viewModel.sex);
    
    RACSignal *isValidGenderSignal = [[[RACObserve(self.logic, viewModel.isValidGender)
        skip:1]
        startWith:@YES]
        distinctUntilChanged];

    [[RACSignal combineLatest:@[genderSignal, isValidGenderSignal]]
        subscribeNext:^(RACTuple *x) {
            PMDreamerGender gender = (PMDreamerGender)[x.first unsignedIntegerValue];
            BOOL isValid = [x.second boolValue];
            @strongify(self);
            if (!isValid) {
                self.girlView.inputState = PMSexViewInputStateInvalid;
                self.boyView.inputState = PMSexViewInputStateInvalid;
            }
            else if (gender == PMDreamerGenderFemale) {
                self.girlView.inputState = PMSexViewInputStateSelected;
                self.boyView.inputState = PMSexViewInputStateNone;
            }
            else if (gender == PMDreamerGenderMale) {
                self.girlView.inputState = PMSexViewInputStateNone;
                self.boyView.inputState = PMSexViewInputStateSelected;
            }
            else {
                self.girlView.inputState = PMSexViewInputStateNone;
                self.boyView.inputState = PMSexViewInputStateNone;
            }
        }];
    
    [[RACObserve(self.logic, viewModel.birthday) ignore:nil] subscribeNext:^(NSDate *date) {
        @strongify(self);
        self.dayLabel.text = self.logic.viewModel.dayBirthday;
        self.monthLabel.text = self.logic.viewModel.monthBirthday;
        self.yearLabel.text = self.logic.viewModel.yearBirthday;
        self.birthdayDatePicker.date = date;
    }];
    
    RAC(self.firstNameView, inputState) = [[[RACObserve(self.logic, viewModel.isValidFirstName)
        skip:1]
        distinctUntilChanged]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];
    
    RAC(self.secondNameView, inputState) = [[[RACObserve(self.logic, viewModel.isValidSecondName)
        skip:1]
        distinctUntilChanged]
        map:^NSNumber *(NSNumber *isValid) {
            BOOL isValidBool = [isValid boolValue];
            return @(isValidBool ? PMCellFillViewInputStateValid : PMCellFillViewInputStateInvalid);
        }];
    
    [[[RACObserve(self.logic, viewModel.isValidBirthDay)
        skip:1]
        distinctUntilChanged]
        subscribeNext:^(NSNumber *isValid) {
            @strongify(self);
            BOOL isValidBool = [isValid boolValue];
            [self.dateInputViewSeparators enumerateObjectsUsingBlock:^(UIView   * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
                view.backgroundColor = isValidBool ? [UIColor whiteColor] : [UIColor invalidStateColor];
            }];
        }];
}
     
- (void)setupLocalization
{
    [super setupLocalization];

    [self.firstNameView.titleButton setTitle: NSLocalizedString(@"auth.registation_step_2.first_name_description", nil) forState:UIControlStateNormal];
    [self.secondNameView.titleButton setTitle: NSLocalizedString(@"auth.registation_step_2.second_name_description", nil) forState:UIControlStateNormal];
    self.titleLabel.text = [NSLocalizedString(@"auth.registation_step_2.title", nil) uppercaseString];
    self.birthdayDescriptionLabel.text = NSLocalizedString(@"auth.registation_step_2.birth_day_description", nil);
    self.dayLabel.text = NSLocalizedString(@"auth.registation_step_2.day", nil);
    self.monthLabel.text = NSLocalizedString(@"auth.registation_step_2.month", nil);
    self.yearLabel.text = NSLocalizedString(@"auth.registation_step_2.year", nil);
    [self.boyView.titleButton setTitle:NSLocalizedString(@"auth.registation_step_2.selected_boy_button", nil) forState:UIControlStateNormal];
    [self.girlView.titleButton setTitle:NSLocalizedString(@"auth.registation_step_2.selected_girl_button", nil) forState:UIControlStateNormal];
    [self.nextButton setTitle:[NSLocalizedString(@"auth.registation_step_2.next_button_title", nil) uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)sendBirthday:(id)sender
{
    [self.acceptButton.rac_command execute:self.birthdayDatePicker.date];
    self.datePickerView.hidden = YES;
}

@end
