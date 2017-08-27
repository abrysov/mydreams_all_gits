//
//  HiddenTabBarController.m
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "SWRevealViewController.h"
#import "MWPhotoBrowser.h"
#import "MyDreamsNavigationController.h"
#import "FriendsViewController.h"
#import "EditProfileViewController.h"
#import "PostDreamViewController.h"
#import "DreambookRootViewController.h"
#import "Helper.h"

@interface MyDreamsNavigationController ()

@end

@implementation MyDreamsNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)navigateTo:(UIViewController *)toViewController from:(UIViewController *)fromViewController {
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL clearStack = NO;
    //UIViewController *lastViewController = [self.viewControllers firstObject];
    if ([viewController isKindOfClass:[BaseViewController class]]) {
        clearStack = [((BaseViewController *)viewController) isSectionRoot];
    }
    
    if (clearStack) {
        // тупо очищаем стек
        [self popToRootViewControllerAnimated:NO];
        //id g = self.viewControllers;
    }
    
    [super pushViewController:viewController animated:animated];    
    [self setupNavigationBar:(BaseViewController *)viewController];
}

- (void)setupNavigationBar:(BaseViewController *)controller {
    if ([self.viewControllers count] > 2) {
        UIImage *menuButtonImage = [[UIImage imageNamed:@"ic_arrow_back_white"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
        controller.navigationItem.leftBarButtonItem = menuButton;
    }
    else {
        UIImage *menuButtonImage = [[UIImage imageNamed:@"ic_menu_white"] imageWithRenderingMode: UIImageRenderingModeAlwaysTemplate];
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:menuButtonImage style:UIBarButtonItemStyleDone target:self action:@selector(showMenu)];
        controller.navigationItem.leftBarButtonItem = menuButton;
    }
}

- (void)showMenu {
   SWRevealViewController *revealController = [self revealViewController];
   [revealController revealToggleAnimated:YES];
}

- (void)goBack {
    [self popViewControllerAnimated:YES];
}

- (void)clearAfterPhotoBrowser {
    UIViewController *vc = [[self viewControllers] lastObject];
    if ([vc isKindOfClass:[MWPhotoBrowser class]]) {
        [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsLandscapePhone];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleLightContent;
//}


@end
