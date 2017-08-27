//
//  UIHelpers.h
//  MyDreams
//
//  Created by Игорь on 29.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef MyDreams_UIHelpers_h
#define MyDreams_UIHelpers_h

#import <UIKit/UIKit.h>
#import "MDTabBar.h"

@interface UIHelpers : NSObject

+ (UIImage *)fixOrientation:(UIImage *)image;
+ (void)setShadow:(UIView *)view;
+ (void)setTabBarAppearence:(MDTabBar *)tabBar;

@end

#endif
