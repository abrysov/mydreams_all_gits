//
//  TabsView.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "TabsView.h"
#import "TabView.h"
#import "Tabs.h"

@implementation TabsView {
    TabsDelegateBlock tabsDelegate;
    CGFloat totalWidth;
    NSArray *tabs;
    NSInteger selectedTabIndex;
}

- (void)setupWithTabs:(NSArray *)tabNames andDelegate:(TabsDelegateBlock)delegate {
    tabsDelegate = delegate;
    
    self.tabsContainer.autoresizesSubviews = NO;
    
    totalWidth = 64;
    NSMutableArray *tabs_ = [[NSMutableArray alloc] init];
    for (int i = 0; i < [tabNames count]; i++) {
        TabView *tab = [TabView addToContainer:self.tabsContainer name:[tabNames objectAtIndex:i] offset:totalWidth];
        [tab setupWithIndex:i andObserver:self];
        totalWidth += tab.frame.size.width;
        [tabs_ addObject:tab];
    }
    self.tabsContainerWidth.constant = totalWidth;
    tabs = [tabs_ copy];
}

- (void)tabSelect:(NSInteger)tabIndex {
    tabsDelegate(tabIndex, selectedTabIndex);
    [self setSelectedTab:tabIndex];
}

- (void)setSelectedTab:(NSInteger)tabIndex {
    for (TabView *tab in tabs) {
        if (tab.index == tabIndex) {
            [tab setSelected];
            CGRect visibleFrame = tab.frame;
            visibleFrame.origin.x -= 50;
            visibleFrame.size.width += 100;
            [self.tabsScrollView scrollRectToVisible:visibleFrame animated:YES];
        }
        else {
            [tab setDeselected];
        }
    }
    selectedTabIndex = tabIndex;
}

- (void)fitToView:(UIView *)view {
    CGRect frame = view.frame;
    frame.origin = self.frame.origin;
    self.frame = frame;
}

@end
