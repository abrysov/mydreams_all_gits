//
//  PMCommentsVC.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCommentsVC.h"
#import "PMCommentsLogic.h"
#import "PMNibManagement.h"
#import "PMPostTableViewCell.h"
#import "PMLoadPageTableViewCell.h"
#import "PMSourceType.h"
#import "PMCommentsViewModel.h"
#import "UISegmentedControl+PM.h"

@interface PMCommentsVC ()
@property (strong, nonatomic) PMCommentsLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sourceSegmentedControl;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@property (strong, nonatomic) NSArray<NSNumber *> *sourceTypeBySegmentedControllIndex;
@end

@implementation PMCommentsVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
         
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }
        }];
    
    [[RACObserve(self.logic, viewModel) ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
    
    [RACObserve(self.logic, viewModel.items) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.sourceSegmentedControl establishChannelToIndexWithTerminal:self.logic.selectSourceTypeTerminal nilValue:@(PMSourceTypeMy) segmentedControllIndex:self.sourceTypeBySegmentedControllIndex];
}

- (void)setupUI
{
    [super setupUI];
    [self buildSegmentedControl];
    self.sourceTypeBySegmentedControllIndex = @[@(PMSourceTypeMy), @(PMSourceTypeSubscriptions)];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMPostTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = [PMPostTableViewCell estimatedRowHeight];
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
        return self.logic.viewModel.items.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMPostTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMPostTableViewCell class] indexPath:indexPath];
        cell.toFullPostCommand = self.logic.toFullPostCommand;
        cell.viewModel = self.logic.viewModel.items[indexPath.row];
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

#pragma mark - private

- (void)buildSegmentedControl
{
    [self.sourceSegmentedControl removeAllSegments];
    [self.sourceSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"news.comments.my_comments", nil) atIndex:0 animated:NO];
    [self.sourceSegmentedControl insertSegmentWithTitle:NSLocalizedString(@"news.comments.comments_friends", nil) atIndex:1 animated:NO];
    self.sourceSegmentedControl.selectedSegmentIndex = 0;
}

-(IBAction)prepareForUnwindComments:(UIStoryboardSegue *)segue {}

@end
