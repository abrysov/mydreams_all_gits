//
//  PMPostDetailContext.m
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedPostContext.h"

@implementation PMDetailedPostContext

+ (instancetype)contextWithPost:(PMPost *)post subject:(RACSubject *)subject
{
    PMDetailedPostContext *context = [self new];
    context.post = post;
    context.postSubject = subject;
    return context;
}

@end
