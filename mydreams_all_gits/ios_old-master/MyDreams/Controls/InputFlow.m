//
//  InputFlow.m
//  MyDreams
//
//  Created by Игорь on 05.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "InputFlow.h"

@implementation InputFlow {
    NSMutableArray *controls;
}

- (void)addControl:(id)control {
    [controls addObject:control];
}

@end
