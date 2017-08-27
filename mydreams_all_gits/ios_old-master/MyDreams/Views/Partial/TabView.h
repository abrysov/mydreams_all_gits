//
//  TabView.h
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tabs.h"


@interface TabView : UIView

@property (assign, nonatomic) NSInteger index;

@property (weak, nonatomic) IBOutlet UILabel *tabNameLabel;
@property (weak, nonatomic) IBOutlet UIView *tabBorder;

- (void)setupWithIndex:(NSInteger)index andObserver:(id<TabProtocol>)observer;
- (void)setSelected;
- (void)setDeselected;

+ (TabView *)addToContainer:(UIView *)container name:(NSString *)tabName offset:(CGFloat)offset;

@end
