//
//  PMFriendshipRequestsVC.m
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestsVC.h"
#import "PMFriendshipRequestView.h"
#import "PMLoadPageView.h"
#import "PMNibManagement.h"
#import "PMListFriendsVC.h"
#import "PMListFriendsLogic.h"
#import "UILabel+PM.h"

@interface PMFriendshipRequestsVC ()
@property (weak, nonatomic) IBOutlet UILabel *requestCountLabel;
@property (weak, nonatomic) IBOutlet UIStackView *frienshipRequestsStackView;
@property (weak, nonatomic) IBOutlet UILabel *totalCountLabel;
@property (weak, nonatomic) IBOutlet UIView *friendshipRequestsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalCounToptAndFriendshipRequestsBottomConstraint;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMFriendshipRequestsVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [[self.logic.addInFriendsCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        [self.delegate updateData];
    }];
    
    [[self.logic.rejectFriendshipRequestCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        [self.delegate updateData];
    }];
    
    [[[RACObserve(self.logic, viewModel.dreamers) ignore:nil] skip:1] subscribeNext:^(NSArray *dreamers) {
        @strongify(self);
        [self fillStackViewWithDreamers:dreamers];
        [self updateConstraintsWithDreamers:dreamers];
    }];
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
         
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }

            [self changeShowLoadPageViewWithEnabled:[enabled boolValue]];
        }];
    
    [RACObserve(self.logic, viewModel.requestCount) subscribeNext:^(NSNumber *count) {
         @strongify(self);
         self.requestCountLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"dreambook.friendship_requests.request_count_description", nil), count];
        [self.requestCountLabel boldSubstring:[count stringValue]];
     }];
    
    [RACObserve(self.logic, viewModel.totalCount) subscribeNext:^(NSNumber *count) {
        @strongify(self);
        self.totalCountLabel.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"dreambook.friendship_requests.total_count_description", nil), count];
        [self.totalCountLabel boldSubstring:[count stringValue]];
    }];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float scrollViewWidth = scrollView.frame.size.width;
    float scrollContentSizeWidth = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    
    if (scrollOffset + scrollViewWidth == scrollContentSizeWidth) {
        self.showingLoadNextPageCell = YES;
    }
}

#pragma mark - private

- (void)fillStackViewWithDreamers:(NSArray *)dreamers
{
    while (self.frienshipRequestsStackView.arrangedSubviews.count > 0) {
        [self.frienshipRequestsStackView.arrangedSubviews[0] removeFromSuperview];
    }
    for (id <PMFriendshipRequestViewModel> viewModel in dreamers) {
        PMFriendshipRequestView *view = [[PMFriendshipRequestView alloc] init];
        view.viewModel = viewModel;
        view.addInFriendsCommand = self.logic.addInFriendsCommand;
        view.rejectFriendshipRequestCommand = self.logic.rejectFriendshipRequestCommand;
        [self.frienshipRequestsStackView addArrangedSubview:view];
    }
    
    PMLoadPageView *view = [[PMLoadPageView alloc] init];
    [self.frienshipRequestsStackView addArrangedSubview:view];
    if (!self.logic.hasNextPage) {
        [view.activity stopAnimating];
    }
}

- (void)updateConstraintsWithDreamers:(NSArray *)dreamers
{
    if (dreamers.count == 0) {
        self.friendshipRequestsView.hidden = YES;
        self.totalCounToptAndFriendshipRequestsBottomConstraint.priority = 501;
        [self.delegate friendshipRequestsVC:self requestsLoaded:NO];
    }
    else {
        self.friendshipRequestsView.hidden = NO;
        self.totalCounToptAndFriendshipRequestsBottomConstraint.priority = 900;
        [self.delegate friendshipRequestsVC:self requestsLoaded:YES];
    }
}

- (void)changeShowLoadPageViewWithEnabled:(BOOL)enabled
{
    if (self.frienshipRequestsStackView.arrangedSubviews.count > 0) {
        PMLoadPageView *view = self.frienshipRequestsStackView.arrangedSubviews[self.frienshipRequestsStackView.arrangedSubviews.count-1];
        if (enabled) {
            [view.activity startAnimating];
        }
        else {
            [view.activity stopAnimating];
        }
    }
}

-(IBAction)prepareForUnwindFriendshipRequests:(UIStoryboardSegue *)segue {}

@end
