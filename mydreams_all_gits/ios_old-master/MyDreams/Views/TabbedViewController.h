//
//  TabbedViewController.h
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SegmentedTabsView.h"

@interface TabbedViewController : BaseViewController

@property (weak, nonatomic) UIViewController *currentTabController;
@property (weak, nonatomic) SegmentedTabsView *tabsView;

@property (weak, nonatomic) IBOutlet UIView *tabsContainerView;
@property (weak, nonatomic) IBOutlet UIView *tabContentView;

- (void)setTabController:(UIViewController *)tabController direction:(NSInteger)direction;

@end
