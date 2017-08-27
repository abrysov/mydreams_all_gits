//
//  PMListFollowersVC.m
//  MyDreams
//
//  Created by user on 24.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListFollowersVC.h"
#import "PMListFollowersLogic.h"
#import "PMDreambookDreamerTableViewCell.h"
#import "PMNibManagement.h"
#import "PMLoadPageTableViewCell.h"
#import "UITextField+PM.h"
#import "UILabel+PM.h"

@interface PMListFollowersVC ()
@property (strong, nonatomic) PMListFollowersLogic *logic;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *activateTextFieldButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *searchingResultCountLabel;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *filtersBarButtonItem;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMListFollowersVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [RACObserve(self.logic.followersViewModel, dreamers) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
         
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }
        }];
    
    [[RACObserve(self.logic, followersViewModel) ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
    
    [RACObserve(self.logic, followersViewModel.totalCount)
        subscribeNext:^(NSNumber *count) {
            @strongify(self);
            self.searchingResultCountLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"dreambook.list_followers.count_description", nil), count];
            [self.searchingResultCountLabel boldSubstring:[count stringValue]];
        }];
}

- (void)setupUI
{
    [super setupUI];
    
    [self.tableView registerCellNIBForClass:[PMDreambookDreamerTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMDreambookDreamerTableViewCell estimatedRowHeight];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.list_followers.title", nil) uppercaseString];
    [self.activateTextFieldButton setTitle:NSLocalizedString(@"dreambook.list_followers.search_text_field_placeholder", nil)  forState:UIControlStateNormal];
    [self.cancelSearchButton setTitle:NSLocalizedString(@"dreambook.list_followers.cancel_search_button_title", nil) forState:UIControlStateNormal];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.tableView;
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.tableView;
}

#pragma mark - actions

- (IBAction)activateTextField:(id)sender
{
    [self showSearchView];
}

- (IBAction)cancelSeachDream:(id)sender
{
    [self hideSearchView];
}

-(IBAction)prepareForUnwindListDreams:(UIStoryboardSegue *)segue {}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.followersViewModel.dreamers.count;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMDreambookDreamerTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreambookDreamerTableViewCell class] indexPath:indexPath];
        cell.viewModel = self.logic.followersViewModel.dreamers[indexPath.row];
        cell.toDreambookCommand = self.logic.toDreambookCommand;
        return cell;
    }
    else if(indexPath.section == 1) {
        return [tableView dequeueReusableCellForClass:[PMLoadPageTableViewCell class] indexPath:indexPath];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageTableViewCell *loadPageTableViewCell = (PMLoadPageTableViewCell*)cell;
        [loadPageTableViewCell.activity startAnimating];
        self.showingLoadNextPageCell = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageTableViewCell *loadPageTableViewCell = (PMLoadPageTableViewCell*)cell;
        [loadPageTableViewCell.activity stopAnimating];
        self.showingLoadNextPageCell = NO;
    }
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

#pragma mark - private

- (void)hideSearchView
{
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    self.activateTextFieldButton.hidden = NO;
    self.bottomConstraint.priority = 850;
    self.backSearchView.hidden = YES;
}

- (void)showSearchView
{
    self.activateTextFieldButton.hidden = YES;
    [self.searchTextField becomeFirstResponder];
    self.bottomConstraint.priority = 999;
    self.backSearchView.hidden = NO;
}

@end
