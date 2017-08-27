//
//  PMBlurm
//  MyDreams
//
//  Created by Иван Ушаков on 12.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBlurNavigationController.h"

@implementation PMBlurNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect bounds = self.navigationBar.bounds;
    bounds = CGRectOffset(bounds, 0, -20.f);
    bounds = CGRectInset(bounds, 0, -20.0f);
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    visualEffectView.frame = bounds;
    visualEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.navigationBar addSubview:visualEffectView];
    
    [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.translucent = YES;
    
    [self.navigationBar sendSubviewToBack:visualEffectView];
}

@end
