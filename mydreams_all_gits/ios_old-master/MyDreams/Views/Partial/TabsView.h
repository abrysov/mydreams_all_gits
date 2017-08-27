//
//  TabsView.h
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"
#import "Tabs.h"

@interface TabsView : UIView<TabProtocol>

//@property (assign, nonatomic) NSInteger selectedTabIndex;

@property (weak, nonatomic) IBOutlet UIView *tabsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabsContainerWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *tabsScrollView;

- (void)setupWithTabs:(NSArray *)tabNames andDelegate:(TabsDelegateBlock)delegate;
- (void)fitToView:(UIView *)view;

@end
