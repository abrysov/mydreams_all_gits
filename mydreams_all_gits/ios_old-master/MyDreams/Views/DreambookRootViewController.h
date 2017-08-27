//
//  DreambookRootViewController.h
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DreambookProfileViewController.h"
#import "MWPhotoBrowser.h"
#import "MDTabBarViewController.h"

@interface DreambookRootViewController : BaseViewController<MDTabBarViewControllerDelegate, TabsRootViewControllerDelegate>

@property (assign, atomic) NSInteger userId;

@end
