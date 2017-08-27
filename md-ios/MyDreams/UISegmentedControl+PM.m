
//
//  UISegmentedControl.m
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UISegmentedControl+PM.h"

@implementation UISegmentedControl (PM)
- (void)establishChannelToIndexWithTerminal:(RACChannelTerminal *)otherTerminal
                                   nilValue:(NSNumber *)nilValue
                     segmentedControllIndex:(NSArray <NSNumber *> *)segmentedControllIndex
{
    RACChannelTerminal *terminal = [self rac_newSelectedSegmentIndexChannelWithNilValue:nilValue];
    
    [[otherTerminal
        map:^(NSNumber *value) {
            return @([segmentedControllIndex indexOfObject:value]);
        }]
        subscribe:terminal];
    
    [[terminal
        map:^(NSNumber *value) {
            return segmentedControllIndex[value.unsignedIntegerValue];
        }]
        subscribe:otherTerminal];
}
@end
