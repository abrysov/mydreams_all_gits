//
//  PMChangeContentControllerSegue.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMChangeContentControllerSegue.h"
#import <RESideMenu/RESideMenu.h>
#import "PMFastLinksContainerController.h"

@implementation PMChangeContentControllerSegue

- (void)perform
{
    RESideMenu *sideMenu = [self.sourceViewController sideMenuViewController];
    NSAssert(sideMenu != nil, @"Side menu should not be bil");
    PMFastLinksContainerController *fastLinkContainer = (PMFastLinksContainerController *)sideMenu.contentViewController;
    fastLinkContainer.controller = self.destinationViewController;
    [sideMenu hideMenuViewController];
}

@end
