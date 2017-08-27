//
//  FriendsViewController.h
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDTabBarViewController.h"
#import "TabbedViewController.h"

@interface FriendsViewController : BaseViewController<MDTabBarViewControllerDelegate, TabsRootViewControllerDelegate>
@property (assign, atomic) NSInteger userId;
@end
