//
//  DreamMainViewController.h
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTabBarViewController.h"
#import "BaseViewController.h"
#import "CommonSearchViewController.h"


@interface DreamRootViewController : BaseViewController<MDTabBarViewControllerDelegate, CommonSearchViewControllerDelegate, TabsRootViewControllerDelegate>

@property (nonatomic) NSInteger dreamId;

@end
