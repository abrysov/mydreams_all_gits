
//
//  PMSubjectContext.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSubjectContext.h"

@implementation PMSubjectContext

+ (instancetype)contextWithSubject:(RACSubject *)subject
{
    PMSubjectContext *context = [self new];
    context.subject = subject;
    return context;
}

@end
