//
//  PMTOP100DreamsVC.m
//  myDreams
//
//  Created by AlbertA on 22/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTOP100DreamsVC.h"
#import "PMTOP100DreamsLogic.h"
#import "PMSearchView.h"
#import "PMTopDreamTableViewCell.h"
#import "PMLoadPageTableViewCell.h"
#import "PMNibManagement.h"
#import "UIColor+MyDreams.h"
#import "PMDreamsViewModel.h"
@interface PMTOP100DreamsVC ()
@property (strong, nonatomic) PMTOP100DreamsLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMTOP100DreamsVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [RACObserve(self.logic.dreamsViewModel, dreams) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
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
            [self scrollToTopAnimated:NO];
        }];
}

- (void)setupUI
{
    [super setupUI];
    
    [self.tableView registerCellNIBForClass:[PMTopDreamTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMTopDreamTableViewCell estimatedRowHeight];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.top_100_dreams.title", nil) uppercaseString];
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

#pragma mark - UITableView

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
        PMTopDreamTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMTopDreamTableViewCell class] indexPath:indexPath];
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

#pragma mark - Private

- (void)scrollToTopAnimated:(BOOL)animated
{
    [self.tableView setContentOffset:CGPointZero animated:animated];
}

@end
