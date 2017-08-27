//
//  TabbedViewController.m
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "TabbedViewController.h"

@interface TabbedViewController ()

@end

@implementation TabbedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [self.tabsView fitToView:self.tabsContainerView];
}

- (void)setTabController:(UIViewController *)tabController direction:(NSInteger)direction {
    if (self.currentTabController) {
        [self swapCurrentControllerWith:tabController direction:direction];
    }
    else {
        [self presentTabController:tabController];
    }
}

- (void)presentTabController:(UIViewController*)tabController {
    if(self.currentTabController) {
        [self removeCurrentTabViewController];
    }
    
    [self addChildViewController:tabController];
    tabController.view.frame = [self frameForDetailController];
    
    [self.tabContentView addSubview:tabController.view];
    self.currentTabController = tabController;
    
    [tabController didMoveToParentViewController:self];
}

- (void)removeCurrentTabViewController{
    [self.currentTabController willMoveToParentViewController:nil];
    [self.currentTabController.view removeFromSuperview];
    [self.currentTabController removeFromParentViewController];
}

- (void)swapCurrentControllerWith:(UIViewController*)viewController direction:(NSInteger)direction {
    [self.currentTabController willMoveToParentViewController:nil];
    
    [self addChildViewController:viewController];
    
    NSInteger k = direction > 0 ? 1 : (direction < 0 ? -1 : 0);
    viewController.view.frame = CGRectMake(k * viewController.view.frame.size.width, 0, viewController.view.frame.size.width, viewController.view.frame.size.height);
    
    [self.tabContentView addSubview:viewController.view];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         viewController.view.frame = self.currentTabController.view.frame;
                         self.currentTabController.view.frame = CGRectMake(0, 0,
                                                                      self.currentTabController.view.frame.size.width, self.currentTabController.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [self.currentTabController.view removeFromSuperview];
                         [self.currentTabController removeFromParentViewController];
                         
                         self.currentTabController = viewController;
                         [self.currentTabController didMoveToParentViewController:self];
                     }];
}


- (CGRect)frameForDetailController{
    CGRect detailFrame = self.tabContentView.bounds;
    return detailFrame;
}

@end
