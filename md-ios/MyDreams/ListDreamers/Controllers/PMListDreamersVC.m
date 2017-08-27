//
//  PMListDreamersVC.m
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListDreamersVC.h"
#import "PMListDreamersLogic.h"
#import "UITextField+PM.h"
#import "PMDreamerTableViewCell.h"
#import "PMLoadPageTableViewCell.h"
#import "PMNibManagement.h"

@interface PMListDreamersVC ()
@property (strong, nonatomic) PMListDreamersLogic *logic;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchDreamersButton;
@property (weak, nonatomic) IBOutlet UILabel *filtersLabel;
@property (weak, nonatomic) IBOutlet UIButton *removeFiltersButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionFiltersLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionResultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchTextFieldBottomConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendToFiltersBarButtonItem;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (strong, nonatomic) IBOutlet UIView *filterDetailsView;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;

@end

@implementation PMListDreamersVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [RACObserve(self.logic, dreamersViewModel.dreamers)
        subscribeNext:^(id x) {
            @strongify(self);
            [self.tableView reloadData];
        }];
    
    [RACObserve(self.logic, dreamersViewModel.totalResult)
        subscribeNext:^(NSString *totalResult) {
            @strongify(self);
            self.descriptionResultLabel.text = totalResult;
        }];
    
    [RACObserve(self.logic, dreamersViewModel.filtersDescription)
        subscribeNext:^(NSString *filters) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero];
            
            if (filters) {
                self.descriptionFiltersLabel.text = filters;
                [self showFilterDetailsView];
            } else {
                [self hideFilterDetailsView];
            }
        }];
    
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    
    self.sendToFiltersBarButtonItem.rac_command = self.logic.showFiltersDreamersCommand;
    self.removeFiltersButton.rac_command = self.logic.removeFiltersCommand;
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;

            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }
        }];
    
    [[RACObserve(self.logic, dreamersViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
}

- (void)setupUI
{
    [super setupUI];
    
    [self.tableView registerCellNIBForClass:[PMDreamerTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMDreamerTableViewCell estimatedRowHeight];
    
    self.tableView.tableHeaderView = nil;
}


- (void)setupLocalization
{
    [super setupLocalization];
    
    self.title = [NSLocalizedString(@"dreambook.list_dreamers.title", nil) uppercaseString];
    [self.searchDreamersButton setTitle:NSLocalizedString(@"dreambook.list_dreamers.search_text_field_placeholder", nil) forState:UIControlStateNormal];
    self.filtersLabel.text = NSLocalizedString(@"dreambook.list_dreamers.filters_title", nil);
    [self.cancelSearchButton setTitle:NSLocalizedString(@"dreambook.list_dreamers.cancel_search_button_title", nil) forState:UIControlStateNormal];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.dreamersViewModel.dreamers.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMDreamerTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreamerTableViewCell class] indexPath:indexPath];
        cell.toDreambookCommand = self.logic.toDreambookCommand;
        cell.viewModel = self.logic.dreamersViewModel.dreamers[indexPath.row];
        return cell;
    }
    else if(indexPath.section == 1) {
        return [tableView dequeueReusableCellForClass:[PMLoadPageTableViewCell class] indexPath:indexPath];
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.searchTextField == textField && [textField.text isEqualToString: @""]) {
        [self hideSearchView];
    }
    return YES;
}

#pragma mark - actions

- (IBAction)activateTextField:(id)sender
{
    [self showTextField];
}

- (IBAction)cancelSeachDream:(id)sender
{
    [self hideSearchView];
}

- (IBAction)clearFiltersButtonHandler:(id)sender
{
    [self hideFilterDetailsView];
}

#pragma mark - private

- (void)hideSearchView
{
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    self.searchDreamersButton.hidden = NO;
    self.searchTextFieldBottomConstraint.priority = 850;
    self.backSearchView.hidden = YES;
}

- (void)showTextField
{
    self.searchDreamersButton.hidden = YES;
    [self.searchTextField becomeFirstResponder];
    self.searchTextFieldBottomConstraint.priority = 999;
    self.backSearchView.hidden = NO;
}

- (void)showFilterDetailsView
{
    self.tableView.tableHeaderView = self.filterDetailsView;
}

- (void)hideFilterDetailsView
{
    self.tableView.tableHeaderView = nil;
}

@end
