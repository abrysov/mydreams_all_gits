//
//  PMDreamDetailContext.m
//  MyDreams
//
//  Created by user on 26.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedDreamContext.h"

@implementation PMDetailedDreamContext

+ (instancetype)contextWithDream:(PMDream *)dream subject:(RACSubject *)subject
{
    PMDetailedDreamContext *context = [self new];
    context.dream = dream;
    context.dreamSubject = subject;
    return context;
}

@end
