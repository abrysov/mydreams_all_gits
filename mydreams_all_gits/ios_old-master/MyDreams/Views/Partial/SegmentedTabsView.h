//
//  SegmentedTabView.h
//  MyDreams
//
//  Created by Игорь on 23.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabView.h"

@interface SegmentedTabsView : UIView<TabProtocol>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (void)setupWithTabs:(NSArray *)tabNames andDelegate:(TabsDelegateBlock)delegate;
- (void)fitToView:(UIView *)view;

@end
