//
//  PMSelectCountryFilterVC.m
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectCountryFilterVC.h"
#import "PMSelectCountryFilterLogic.h"
#import "PMCountyCell.h"
#import "UITextField+PM.h"
#import "PMCountryViewModelImpl.h"
#import "DreambookTableViewCells.h"

@interface PMSelectCountryFilterVC () <UITextFieldDelegate>
@property (strong, nonatomic) PMSelectCountryFilterLogic *logic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *selectionLocationTableView;
@property (weak, nonatomic) IBOutlet UIButton *activateTextFieldButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *compressionConstraint;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;

@end

@implementation PMSelectCountryFilterVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    [[RACObserve(self.logic, countriesViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.selectionLocationTableView reloadData];
         }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.title = [NSLocalizedString(@"auth.select_country.title", nil) uppercaseString];
    [self.activateTextFieldButton setTitle:NSLocalizedString(@"dreambook.select_country_filter.search_placeholder", nil) forState:UIControlStateNormal];
    [self.cancelSearchButton setTitle:NSLocalizedString(@"dreambook.select_country_filter.cancel_search_button_title", nil) forState:UIControlStateNormal];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.selectionLocationTableView;
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.selectionLocationTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logic.countriesViewModel.countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCountyCell *cell = (PMCountyCell *)[tableView dequeueReusableCellWithIdentifier:self.cell.kPMReuseIdentifierFilterCountryCell];
    cell.viewModel = self.logic.countriesViewModel.countries[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.logic selectCountryWithIndex:indexPath.row];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.searchTextField == textField && [textField.text isEqualToString:@""]) {
        [self hideSearchView];
    }
    return YES;
}

#pragma mark - actions

- (IBAction)activateTextField:(id)sender
{
    [self showSearchView];
}

- (IBAction)cancelSearchCountry:(id)sender
{
    [self hideSearchView];
}

#pragma mark - private

- (void)hideSearchView
{
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    self.activateTextFieldButton.hidden = NO;
    self.compressionConstraint.priority = 850;
    self.backSearchView.hidden = YES;
}

- (void)showSearchView
{
    self.activateTextFieldButton.hidden = YES;
    [self.searchTextField becomeFirstResponder];
    self.compressionConstraint.priority = 999;
    self.backSearchView.hidden = NO;
}

-(IBAction)prepareForUnwindSelectCountryFilter:(UIStoryboardSegue *)segue {}

@end
