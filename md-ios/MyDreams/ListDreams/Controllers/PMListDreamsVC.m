//
//  PMListDreamsVC.m
//  myDreams
//
//  Created by AlbertA on 25/04/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListDreamsVC.h"
#import "PMListDreamsLogic.h"
#import "PMSegmentControl.h"
#import "UIColor+MyDreams.h"
#import "PMNibManagement.h"
#import "PMDreamTableViewCell.h"
#import "PMLoadPageTableViewCell.h"
#import "PMDreamsViewModel.h"
#import "UITextField+PM.h"
#import "PMDreamViewModel.h"

@interface PMListDreamsVC () <PMSegmentControlDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) PMListDreamsLogic *logic;
@property (weak, nonatomic) IBOutlet UITextField *searchDreamTextField;
@property (weak, nonatomic) IBOutlet UIView *containerForSegmentControl;
@property (weak, nonatomic) IBOutlet UIButton *activateTextFieldButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (weak, nonatomic) IBOutlet UIView *backSearchView;

@property (strong, nonatomic) NSArray *commandsForSegmentedControll;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMListDreamsVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [RACObserve(self.logic.dreamsViewModel, dreams) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.searchDreamTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    
    self.commandsForSegmentedControll = @[self.logic.freshDreamsCommand,
                                          self.logic.likedDreamsCommand,
                                          self.logic.hotDreamsCommand];
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
            
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }
        }];

    [[RACObserve(self.logic, dreamsViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
}

- (void)setupUI
{
    [super setupUI];
    
    [self.tableView registerCellNIBForClass:[PMDreamTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMDreamTableViewCell estimatedRowHeight];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    PMSegmentControl *segmentControl = [[PMSegmentControl alloc] initWithItems:
                                                                @[[NSLocalizedString(@"dreambook.list_dreams.new_dreams", nil) uppercaseString],
                                                                  [NSLocalizedString(@"dreambook.list_dreams.popular_dreams", nil) uppercaseString],
                                                                  [NSLocalizedString(@"dreambook.list_dreams.most_discussed_dreams", nil) uppercaseString],]
                                                               bottomLineColor:[UIColor listDreamsActiveLineButtonColor]
                                                                         class:[PMSwitchButtonView class]];
    
    [self.containerForSegmentControl addSubview:segmentControl];
    
    [segmentControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerForSegmentControl);
    }];
    segmentControl.delegate = self;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.list_dreams.title", nil) uppercaseString];
    [self.activateTextFieldButton setTitle:NSLocalizedString(@"dreambook.list_dreams.search_text_field_placeholder", nil)  forState:UIControlStateNormal];
    [self.cancelSearchButton setTitle:NSLocalizedString(@"dreambook.list_dreams.cancel_search_button_title", nil) forState:UIControlStateNormal];
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
        return self.logic.dreamsViewModel.dreams.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMDreamTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreamTableViewCell class] indexPath:indexPath];
        cell.toFullDreamCommand = self.logic.toFullDreamCommand;
        cell.viewModel = self.logic.dreamsViewModel.dreams[indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	id <PMDreamViewModel> dreamViewModel = self.logic.dreamsViewModel.dreams[indexPath.row];
	[self.logic.toFullDreamCommand execute:dreamViewModel.dreamIdx];
}

#pragma mark - PMSegmentControlDelegate

- (void)SegmentControl:(PMSegmentControl *)segmentControl SwitchedOn:(NSInteger)index
{
    RACCommand *command = self.commandsForSegmentedControll[index];
    [command execute:self];
    [self.tableView setContentOffset:CGPointZero animated:NO];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.searchDreamTextField == textField && [textField.text isEqualToString:@""]) {
        [self hideSearchView];
    }
    return YES;
}

#pragma mark - private

- (void)hideSearchView
{
    self.searchDreamTextField.text = @"";
    [self.searchDreamTextField resignFirstResponder];
    self.activateTextFieldButton.hidden = NO;
    self.botConstraint.priority = 850;
    self.backSearchView.hidden = YES;
}

- (void)showSearchView
{
    self.activateTextFieldButton.hidden = YES;
    [self.searchDreamTextField becomeFirstResponder];
    self.botConstraint.priority = 999;
    self.backSearchView.hidden = NO;
}

@end
