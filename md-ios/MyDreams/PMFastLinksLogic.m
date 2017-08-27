//
//  PMFastLinksLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFastLinksLogic.h"
#import "PMApplicationRouter.h"

@interface PMFastLinksLogic ()
@property (assign, nonatomic) PMMenuItem selectedMenuItem;
@end

@implementation PMFastLinksLogic

- (void)startLogic
{
    [super startLogic];
    
    RAC(self, selectedMenuItem) = RACObserve(self.router, selectedMenuItem);
}

- (void)openMenuItem:(PMMenuItem)menuItem
{
    [self.router openMenuItem:menuItem];
}

@end
