//
//  PromoViewController.m
//  MyDreams
//
//  Created by Игорь on 22.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "PromoViewController.h"
#import "PromoSlideViewController.h"
#import "YZSwipeBetweenViewController.h"
#import "PostDreamViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "PromoSlideIndicator.h"
#import "Helper.h"

@interface PromoViewController ()

@end

@implementation PromoViewController {
    PromoSlideIndicator *indicator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self viewControllersData];
    
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    self.scrollView.delegate = self;
    
    /*indicator = [[[NSBundle mainBundle] loadNibNamed:@"PromoSlideIndicator" owner:nil options:nil] objectAtIndex:0];
    
    CGRect indicatorFrame = indicator.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    indicatorFrame.origin.x = screenFrame.size.width / 2 - indicatorFrame.size.width / 2;
    indicatorFrame.origin.y = screenFrame.size.height - 60;
    indicator.frame = indicatorFrame;
    [self.view addSubview:indicator];
    [self updateIndicator];*/
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    if (page == 3) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [Helper setPromoSaw:YES];
        [app setupAuthorizedNavigation];
        
        // допущение, что используется SWRevealViewController как root, и frontViewController как navigation
        UINavigationController *navigationController = (UINavigationController *)((SWRevealViewController *)[[app window] rootViewController]).frontViewController;
        PostDreamViewController *postDreamViewController = [[PostDreamViewController alloc] initWithNibName:@"PostDreamViewController" bundle:nil];
        [navigationController pushViewController:postDreamViewController animated:NO];
    }
    [self updateIndicator];
}

- (void)updateIndicator {
    int page = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
    UIColor *color = [PromoSlideViewController getColor:page + 1];
    UIColor *inactiveColor = [color colorWithAlphaComponent:0.5];
    indicator.one.textColor = inactiveColor;
    indicator.two.textColor = inactiveColor;
    indicator.three.textColor = inactiveColor;
    if (page == 0) {
        indicator.one.textColor = color;
    }
    else if (page == 1) {
        indicator.two.textColor = color;
    }
    else if (page == 2) {
        indicator.three.textColor = color;
    }
}

- (NSArray<UIViewController *> *)viewControllersData {
    PromoSlideViewController *vc1 = [[PromoSlideViewController alloc] initWithNibName:@"Promo1SlideView" bundle:nil];
    vc1.index = 1;
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    nc1.navigationBarHidden = YES;
    
    PromoSlideViewController *vc2 = [[PromoSlideViewController alloc] initWithNibName:@"Promo2SlideView" bundle:nil];
    vc2.index = 2;
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    nc2.navigationBarHidden = YES;
    
    PromoSlideViewController *vc3 = [[PromoSlideViewController alloc] initWithNibName:@"Promo3SlideView" bundle:nil];
    vc3.index = 3;
    UINavigationController *nc3 = [[UINavigationController alloc] initWithRootViewController:vc3];
    nc3.navigationBarHidden = YES;
    
    PostDreamViewController *vc4 = [[PostDreamViewController alloc] initWithNibName:@"PostDreamViewController" bundle:nil];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
   
    // хак - закрасить нав-бар с задержкой, после viewDidLoad
    dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1.0);
    dispatch_after(delay, dispatch_get_main_queue(), ^(void) {
        [vc4.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
        [vc4 setupAppearence];
        
    });
    
    return @[nc1, nc2, nc3, nc4];
}

@end
