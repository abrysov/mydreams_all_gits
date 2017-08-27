//
//  PromoViewController.h
//  MyDreams
//
//  Created by Игорь on 22.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSwipeBetweenViewController.h"

@interface PromoViewController : YZSwipeBetweenViewController<UIScrollViewDelegate>

- (NSArray<UIViewController *> *)viewControllersData;

@end
