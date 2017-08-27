//
//  PMDetailedLikesVC.m
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedLikesVC.h"
#import "PMDetailedLikesLogic.h"
#import "PMDreambookDreamerTableViewCell.h"
#import "PMNibManagement.h"
#import "UILabel+PM.h"
#import "PMLoadPageTableViewCell.h"

@interface PMDetailedLikesVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (strong, nonatomic) PMDetailedLikesLogic *logic;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMDetailedLikesVC
@dynamic logic;


- (void)setupUI
{
	[super setupUI];
	[self.tableView registerCellNIBForClass:[PMDreambookDreamerTableViewCell class]];
	[self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];

	//if set in storyboard height equal 65.5 and it breaks autolayout engine
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = [PMDreambookDreamerTableViewCell estimatedRowHeight];
}
- (void)setupLocalization
{
	[super setupLocalization];
	self.title = self.logic.viewModel.title;
}

- (void)bindUIWithLogics
{
	[super bindUIWithLogics];
	@weakify(self);

	[RACObserve(self.logic.viewModel, dreamers) subscribeNext:^(id x) {
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

	[RACObserve(self.logic, viewModel.totalCount) subscribeNext:^(NSNumber *count) {
		@strongify(self);
		self.totalCountLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"dreambook.detailed_likes.total_count", nil), count];
		[self.totalCountLabel boldSubstring:[count stringValue]];
	}];
}

- (UIView *)viewForStatesViewsConstraints
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
	return (section == 0) ? self.logic.viewModel.dreamers.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
		PMDreambookDreamerTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMDreambookDreamerTableViewCell class] indexPath:indexPath];
		cell.viewModel = self.logic.viewModel.dreamers[indexPath.row];
		return cell;
	}
	else if (indexPath.section == 1) {
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

@end
