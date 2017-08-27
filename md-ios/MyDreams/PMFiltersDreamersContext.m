//
//  PMFiltersDreamersContext.m
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFiltersDreamersContext.h"

@implementation PMFiltersDreamersContext

+ (PMFiltersDreamersContext *)contextWithFilterForm:(PMDreamerFilterForm *)dreamerFilterForm
{
    PMFiltersDreamersContext *context = [self new];
    context.filterForm = dreamerFilterForm;
    return context;
}

@end
