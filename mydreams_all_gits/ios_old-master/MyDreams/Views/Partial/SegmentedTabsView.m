//
//  SegmentedTabView.m
//  MyDreams
//
//  Created by Игорь on 23.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "SegmentedTabsView.h"

@implementation SegmentedTabsView {
    TabsDelegateBlock tabsDelegate;
    CGFloat totalWidth;
    NSArray *tabs;
    NSInteger selectedTabIndex;
}

- (void)setupWithTabs:(NSArray *)tabNames andDelegate:(TabsDelegateBlock)delegate {
    tabsDelegate = delegate;
    
    while (self.segmentedControl.numberOfSegments > 0) {
        [self.segmentedControl removeSegmentAtIndex:0 animated:NO];
    }
    [self.segmentedControl initWithItems:tabNames];
    [self.segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.selectedSegmentIndex = 1;
}

- (void)segmentAction:(UISegmentedControl *)segment {
    tabsDelegate(segment.selectedSegmentIndex, selectedTabIndex);
}

- (void)tabSelect:(NSInteger)tabIndex {
    tabsDelegate(tabIndex, selectedTabIndex);
    [self.segmentedControl setSelectedSegmentIndex:tabIndex];
    selectedTabIndex = tabIndex;
}

- (void)fitToView:(UIView *)view {
    CGRect frame = view.frame;
    frame.origin = self.frame.origin;
    self.frame = frame;
}

@end
