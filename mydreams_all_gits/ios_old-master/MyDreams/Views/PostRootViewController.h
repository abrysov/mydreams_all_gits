//
//  PostRootViewController.h
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "MDTabBarViewController.h"
#import "BaseViewController.h"
#import "CommonSearchViewController.h"

@interface PostRootViewController : BaseViewController<MDTabBarViewControllerDelegate, TabsRootViewControllerDelegate>

@property (nonatomic) NSInteger postId;

@end
