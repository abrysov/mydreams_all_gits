//
//  UISegmentedControl.h
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UISegmentedControl (PM)
- (void)establishChannelToIndexWithTerminal:(RACChannelTerminal *)otherTerminal
                                   nilValue:(NSNumber *)nilValue
                     segmentedControllIndex:(NSArray<NSNumber *> *)segmentedControllIndex;
@end
