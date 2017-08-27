//
//  NNAppearanceConfig.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAppearanceConfig.h"
#import "UIImage+PM.h"

@implementation PMAppearanceConfig

- (void)apply
{
    [self tabBar];
    [self navigationBar];
}

#pragma makr - private

- (void)tabBar
{
//    [UITabBar appearance].translucent = NO;
//    [UITabBar appearance].barTintColor = [UIColor NN_backgroundBlack];
//    [UITabBar appearance].tintColor = [UIColor NN_brown];
//    [UITabBar appearance].backgroundImage = [UIImage imageWithColor:[UIColor NN_backgroundBlack]];
//    [UITabBar appearance].shadowImage = [UIImage imageWithColor:[UIColor NN_backgroundGrayMiddle]];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor NN_textGrayMiddle],
//                                                        NSFontAttributeName: [UIFont NN_regularWithSize:13.f]}
//                                             forState:UIControlStateNormal];
//    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor NN_textGrayMiddle],
//                                                        NSFontAttributeName: [UIFont NN_regularWithSize:13.f]}
//                                             forState:UIControlStateSelected];
}

- (void)navigationBar
{
//    [UINavigationBar appearance].translucent = NO;
//    [UINavigationBar appearance].barTintColor = [UIColor NN_backgroundGrayMiddle];
//    [UINavigationBar appearance].tintColor = [UIColor NN_white];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor NN_backgroundGrayMiddle]]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
//    
//    [UINavigationBar appearance].shadowImage = [UIImage imageWithColor:[UIColor NN_backgroundGrayMiddle]];
//    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                         NSFontAttributeName: [UIFont NN_mediumWithSize:16.0f]};
}

@end
