//
//  PMNewsFeedVC.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsFeedVC.h"
#import "PMNewsFeedLogic.h"
#import "PMNibManagement.h"
#import "PMPostTableViewCell.h"
#import "PMLoadPageTableViewCell.h"
#import "PMNewsFeedViewModel.h"

@interface PMNewsFeedVC ()
@property (strong, nonatomic) PMNewsFeedLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createPostButton;
@property (weak, nonatomic) IBOutlet UIButton *postsCountButton;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMNewsFeedVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.createPostButton.rac_command = self.logic.createPostCommand;
    
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
    
    [RACObserve(self.logic, viewModel.postsCount) subscribeNext:^(NSString *postsCount) {
        @strongify(self);
        [self.postsCountButton setTitle:postsCount forState:UIControlStateNormal];
    }];
}

- (void)setupUI
{
    [super setupUI];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMPostTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.estimatedRowHeight = [PMPostTableViewCell estimatedRowHeight];
}

- (void)setupLocalization
{
    [super setupLocalization];
    [self.createPostButton setTitle:NSLocalizedString(@"news.news_feed.create_post_title", nil) forState:UIControlStateNormal];
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

-(IBAction)prepareForUnwindNewsFeed:(UIStoryboardSegue *)segue {}

@end
