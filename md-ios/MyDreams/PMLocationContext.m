//
//  PMLocationContext.m
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocationContext.h"

@implementation PMLocationContext
+ (PMLocationContext *)contextWithSubject:(RACSubject *)localitySubject
{
    PMLocationContext *context = [self new];
    context.localitySubject = localitySubject;
    return context;
}
@end
