//
//  PMFiltersDreamersVC.m
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFiltersDreamersVC.h"
#import "PMFiltersDreamersLogic.h"
#import "CellFilterView.h"
#import "PMBorderedButtonWithResult.h"
#import "UITextField+PM.h"
#import "UISegmentedControl+RACSignalSupport.h"
#import "UIColor+MyDreams.h"
#import "RACKVOChannel.h"
#import "PMDreamer.h"
#import "UISegmentedControl+PM.h"

@interface PMFiltersDreamersVC ()
@property (strong, nonatomic) PMFiltersDreamersLogic *logic;
@property (weak, nonatomic) IBOutlet UILabel *countryDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCountryButton;

@property (weak, nonatomic) IBOutlet UILabel *cityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectCityButton;

@property (weak, nonatomic) IBOutlet UILabel *ageDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *fromAgeTextField;
@property (weak, nonatomic) IBOutlet UITextField *beforeAgeTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *selectSexSegmentedControl;

@property (weak, nonatomic) IBOutlet CellFilterView *allDreamersView;
@property (weak, nonatomic) IBOutlet CellFilterView *recentDreamersView;
@property (weak, nonatomic) IBOutlet CellFilterView *popularDreamersView;
@property (weak, nonatomic) IBOutlet CellFilterView *vipDreamersView;
@property (weak, nonatomic) IBOutlet CellFilterView *onlineDreamersView;
@property (weak, nonatomic) IBOutlet UIButton *resetFiltersButton;
@property (weak, nonatomic) IBOutlet PMBorderedButtonWithResult *sendResultButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;

@property (strong, nonatomic) NSArray<NSNumber *> *genderBySegmentedControllIndex;
@end

@implementation PMFiltersDreamersVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.fromAgeTextField.keyboardType = UIKeyboardTypePhonePad;
    self.beforeAgeTextField.keyboardType = UIKeyboardTypePhonePad;
    [self buildSegmentedControl];

    self.genderBySegmentedControllIndex = @[@(PMDreamerGenderFemale), @(PMDreamerGenderUnknow), @(PMDreamerGenderMale)];
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.sendResultButton.rac_command = self.logic.backCommand;
    
    self.selectCountryButton.rac_command = self.logic.toSelectCountryCommand;
    self.selectCityButton.rac_command = self.logic.toSelectLocalityCommand;
    
    self.allDreamersView.button.rac_command = self.logic.changeAllOptionCommand;
    self.recentDreamersView.button.rac_command = self.logic.changeNewOptionCommand;
    self.popularDreamersView.button.rac_command = self.logic.changeTopOptionCommand;
    self.vipDreamersView.button.rac_command = self.logic.changeVipOptionCommand;
    self.onlineDreamersView.button.rac_command = self.logic.changeOnlineOptionCommand;
    
    self.resetFiltersButton.rac_command = self.logic.resetFiltersCommand;
    
    RAC(self.recentDreamersView, inputState) = [self mapWithState:RACObserve(self.logic, viewModel.isNew)];
    RAC(self.popularDreamersView, inputState) = [self mapWithState:RACObserve(self.logic, viewModel.isPopular)];
    RAC(self.vipDreamersView, inputState) = [self mapWithState:RACObserve(self.logic, viewModel.isVip)];
    RAC(self.onlineDreamersView, inputState) = [self mapWithState:RACObserve(self.logic, viewModel.isOnline)];
    
    [RACObserve(self.logic, viewModel.totalResult) subscribeNext:^(NSString *title) {
        self.sendResultButton.inputState = PMBorderedButtonWithResultStateActive;
        [self.sendResultButton setTitle:title forState:UIControlStateNormal];
    }];
    
    [RACObserve(self.logic, viewModel.notFound) subscribeNext:^(NSNumber *notFound) {
        if ([notFound boolValue]) {
            self.sendResultButton.inputState = PMBorderedButtonWithResultStateInactive;
        }
    }];
    
    RAC(self.countryValueLabel, text) = RACObserve(self.logic, viewModel.nameCountry);
    RAC(self.cityValueLabel, text) = RACObserve(self.logic, viewModel.nameCity);
    
    [self.fromAgeTextField establishChannelToTextWithTerminal:self.logic.fromAgeTerminal];
    [self.beforeAgeTextField establishChannelToTextWithTerminal:self.logic.toAgeTerminal];
    
    [self.selectSexSegmentedControl establishChannelToIndexWithTerminal:self.logic.selectGenderTerminal nilValue:@(PMDreamerGenderUnknow) segmentedControllIndex:self.genderBySegmentedControllIndex];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.title = [NSLocalizedString(@"dreambook.filters_dreamers.title", nil) uppercaseString];
    self.countryDescriptionLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_country", nil);
    self.cityDescriptionLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_city", nil);
    self.ageDescriptionLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_age", nil);
    self.fromAgeTextField.placeholder = NSLocalizedString(@"dreambook.filters_dreamers.from_age_placeholder", nil);
    self.beforeAgeTextField.placeholder = NSLocalizedString(@"dreambook.filters_dreamers.before_age_placeholder", nil);
    self.allDreamersView.titleLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_all_dreamers", nil);
    self.recentDreamersView.titleLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_new_dreamers", nil);
    self.popularDreamersView.titleLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_popular_dreamers", nil);
    self.vipDreamersView.titleLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_vip_dreamers", nil);
    self.onlineDreamersView.titleLabel.text = NSLocalizedString(@"dreambook.filters_dreamers.description_online_dreamers", nil);
    
    [self.resetFiltersButton setTitle:NSLocalizedString(@"dreambook.filters_dreamers.reset_filters", nil) forState:UIControlStateNormal];
}

- (IBAction)touchUpSenderColor:(UIButton *)sender
{
     sender.backgroundColor = [UIColor clearColor];
    
}

- (IBAction)touchDownSenderColor:(UIButton *)sender {
   sender.backgroundColor = [UIColor dreambookTableViewCellSelectionColor];
}
#pragma mark - private

- (RACSignal *)mapWithState:(RACSignal *)signal
{
    return [signal map:^id(NSNumber *value) {
        [self filterOptions];
        BOOL isValueBool = [value boolValue];
        return @(isValueBool ? CellFilterViewStateActive : CellFilterViewStateInactive);
    }];
}

- (void)buildSegmentedControl
{
    [self.selectSexSegmentedControl removeAllSegments];
    [self.selectSexSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"dreambook.filters_dreamers.gender_woman", nil) atIndex:0 animated:NO];
    [self.selectSexSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"dreambook.filters_dreamers.gender_all", nil) atIndex:1 animated:NO];
    [self.selectSexSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"dreambook.filters_dreamers.gender_man", nil) atIndex:2 animated:NO];
    self.selectSexSegmentedControl.selectedSegmentIndex = 1;
}

- (void)filterOptions
{
    if ((self.logic.viewModel.isNew == NO) &&
        (self.logic.viewModel.isVip == NO) &&
        (self.logic.viewModel.isOnline == NO) &&
        (self.logic.viewModel.isPopular == NO)) {
        self.allDreamersView.inputState = CellFilterViewStateActive;
    } else {
        self.allDreamersView.inputState = CellFilterViewStateInactive;
    }
}

-(IBAction)prepareForUnwindFiltersDreamers:(UIStoryboardSegue *)segue {}

@end
