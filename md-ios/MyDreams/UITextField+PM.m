//
//  UITextField+PM.m
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UITextField+PM.h"

@implementation UITextField (PM)

- (void)establishChannelToTextWithTerminal:(RACChannelTerminal *)otherTerminal
{
    RACChannelTerminal *terminal = self.rac_newTextChannel;
    [otherTerminal subscribe:terminal];
    [[terminal skip:1] subscribe:otherTerminal];
}

@end
