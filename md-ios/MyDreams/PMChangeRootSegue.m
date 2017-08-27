//
//  NNChangeRootSegue.m
//  MyDreams
//
//  Created by Иван Ушаков on 02.11.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangeRootSegue.h"

@implementation PMChangeRootSegue

- (void)perform
{
    UIViewController *destinationVC = self.destinationViewController;
    [UIApplication sharedApplication].keyWindow.rootViewController = destinationVC;
}

@end
