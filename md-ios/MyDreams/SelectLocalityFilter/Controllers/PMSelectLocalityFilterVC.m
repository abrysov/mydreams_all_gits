//
//  PMSelectLocalityFilterVC.m
//  myDreams
//
//  Created by AlbertA on 11/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectLocalityFilterVC.h"
#import "PMSelectLocalityFilterLogic.h"
#import "PMCellFillView.h"
#import "UITextField+PM.h"
#import "PMLocalityCell.h"
#import "PMLocalityViewModel.h"
#import "DreambookTableViewCells.h"

@interface PMSelectLocalityFilterVC () <UITextFieldDelegate>
@property (strong, nonatomic) PMSelectLocalityFilterLogic *logic;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *selectionLocationTableView;
@property (weak, nonatomic) IBOutlet UIButton *activateTextFieldButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *compressionConstraint;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@end

@implementation PMSelectLocalityFilterVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    @weakify(self);
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    [[RACObserve(self.logic, localitiesViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.selectionLocationTableView reloadData];
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    [self.activateTextFieldButton setTitle:NSLocalizedString(@"dreambook.select_locality_filter.search_placeholder", nil) forState:UIControlStateNormal];
    self.title = [NSLocalizedString(@"auth.select_locality.title", nil) uppercaseString];
    [self.cancelSearchButton setTitle:NSLocalizedString(@"dreambook.select_locality_filter.cancel_search_button_title", nil) forState:UIControlStateNormal];
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

#pragma - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.logic selectLocalityWithIndex:indexPath.row];
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logic.localitiesViewModel.localities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMLocalityCell *cell = (PMLocalityCell *)[tableView dequeueReusableCellWithIdentifier:self.cell.kPMReuseIdentifierFilterLocalityCell];
    cell.viewModel = self.logic.localitiesViewModel.localities[indexPath.row];
    return cell;
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

- (IBAction)cancelBackSearchView:(id)sender
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

- (IBAction)prepareForUnwindSelectLocality:(UIStoryboardSegue *)segue {}

@end
