//
//  PromoSlideViewController.m
//  MyDreams
//
//  Created by Игорь on 22.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "PromoSlideViewController.h"
#import "Helper.h"

@interface PromoSlideViewController ()

@end

@implementation PromoSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UIColor *color = [PromoSlideViewController getColor:self.index];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor = color;
    [self.navigationController.view addSubview:statusBarView];
    
    //[[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //[[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
}

+ (UIColor *)getColor:(NSInteger)index {
    if (index == 1) {
        return [Helper colorWithHexString:@"#78b873"];
    }
    else if (index == 2) {
        return [Helper colorWithHexString:@"#638fca"];
    }
    else if (index == 3) {
        return [Helper colorWithHexString:@"#5f4b9a"];
    }
    return [UIColor clearColor];
}

@end
