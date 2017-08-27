//
//  PMFastLinksContainerController.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"

typedef NS_ENUM(NSUInteger, PMFastLinksContainerControllerStyle) {
    PMFastLinksContainerControllerStyleLight,
    PMFastLinksContainerControllerStyleDark,
};

@interface PMFastLinksContainerController : PMBaseVC
@property (strong, readwrite, nonatomic) IBInspectable NSString *contentViewStoryboardID;
@property (nonatomic, strong) IBOutlet UIViewController *controller;
@property (nonatomic, assign) BOOL underTabBar;
@property (nonatomic, assign) PMFastLinksContainerControllerStyle style;
@end

@interface UIViewController (PMFastLinksContainerController)
- (PMFastLinksContainerController *)fastLinksContainer;
@end
