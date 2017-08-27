//
//  PMSearchVC.m
//  myDreams
//
//  Created by AlbertA on 26/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchVC.h"
#import "PMSearchLogic.h"
#import "PMSearchView.h"
#import "PMDreamTableViewCell.h"
#import "PMDreamerTableViewCell.h"
#import "PMPostTableViewCell.h"
#import "PMNibManagement.h"
#import "PMLoadPageTableViewCell.h"
#import "PMSegmentControl.h"
#import "UIColor+MyDreams.h"
#import "PMSearchViewModel.h"
#import "PMPage.h"

@interface PMSearchVC () <PMSegmentControlDelegate>
@property (strong, nonatomic) PMSearchLogic *logic;
@property (weak, nonatomic) IBOutlet PMSearchView *searchView;
@property (weak, nonatomic) IBOutlet UIView *containerForSegmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMSearchVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    [self.searchView establishChannelToTextWithTerminal:self.logic.searchTerminal];

    
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
    
    [[RACObserve(self.logic, currentPage)
        filter:^BOOL(PMPage *page) {
            return [page.page intValue] == 1;
        }]
        subscribeNext:^(id value) {
            @strongify(self);
            switch (self.logic.viewModel.type) {
                case PMSearchTypeDream:
                    self.tableView.estimatedRowHeight = [PMDreamTableViewCell estimatedRowHeight];
                    break;
                case PMSearchTypeDreamer:
                    self.tableView.estimatedRowHeight = [PMDreamerTableViewCell estimatedRowHeight];
                    break;
                case PMSearchTypePost:
                    self.tableView.estimatedRowHeight = [PMPostTableViewCell estimatedRowHeight];
                    break;
                default:
                    break;
            }
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
}

- (void)setupUI
{
    [super setupUI];
    
    [self.tableView registerCellNIBForClass:[PMDreamTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMDreamerTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMPostTableViewCell class]];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    PMSegmentControl *segmentControl = [[PMSegmentControl alloc] initWithItems:
                                           @[[NSLocalizedString(@"menu.search.dreams_title", nil) uppercaseString],
                                             [NSLocalizedString(@"menu.search.posts_title", nil) uppercaseString],
                                             [NSLocalizedString(@"menu.search.dreamers_title", nil) uppercaseString],]
                                                               bottomLineColor:[UIColor listDreamsActiveLineButtonColor]
                                                                         class:[PMSwitchButtonView class]];
    
    [self.containerForSegmentControl addSubview:segmentControl];
    
    @weakify(self);
    [segmentControl mas_updateConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.containerForSegmentControl);
    }];
    segmentControl.delegate = self;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"menu.search.title", nil) uppercaseString];
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
        switch (self.logic.viewModel.type) {
            case PMSearchTypeDream:
                return [self dreamTableViewCellWithTableView:tableView indexPath:indexPath];
            case PMSearchTypeDreamer:
                return [self dreamerTableVIewCellWithTableView:tableView indexPath:indexPath];
            case PMSearchTypePost:
                return [self postTableViewCellWithTableView:tableView indexPath:indexPath];
            default:
                break;
        }
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

#pragma mark - PMSegmentControlDelegate

- (void)SegmentControl:(PMSegmentControl *)segmentControl SwitchedOn:(NSInteger)index
{
    switch (index) {
        case 0:
            [self.logic.searchItemsCommand execute:@(PMSearchTypeDream)];
            break;
        case 1:
            [self.logic.searchItemsCommand execute:@(PMSearchTypePost)];
            break;
        case 2:
            [self.logic.searchItemsCommand execute:@(PMSearchTypeDreamer)];
        default:
            break;
    }
}

#pragma mark - private

- (UITableViewCell *)postTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    PMPostTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMPostTableViewCell class] indexPath:indexPath];
    cell.toFullPostCommand = self.logic.toFullPostCommand;
    cell.viewModel = self.logic.viewModel.items[indexPath.row];
    return cell;
}

- (UITableViewCell *)dreamTableViewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    PMDreamTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreamTableViewCell class] indexPath:indexPath];
    cell.toFullDreamCommand = self.logic.toFullDreamCommand;
    cell.viewModel = self.logic.viewModel.items[indexPath.row];
    return cell;
}

- (UITableViewCell *)dreamerTableVIewCellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    PMDreamerTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreamerTableViewCell class] indexPath:indexPath];
    cell.toDreambookCommand = self.logic.toDreambookCommand;
    cell.viewModel = self.logic.viewModel.items[indexPath.row];
    return cell;
}

-(IBAction)prepareForUnwindSearch:(UIStoryboardSegue *)segue {}

@end
