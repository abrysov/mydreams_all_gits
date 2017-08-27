//
//  PMBaseModelIdxContext.m
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModelIdxContext.h"

@implementation PMBaseModelIdxContext

+ (PMBaseModelIdxContext *)contextWithIdx:(NSNumber *)idx
{
    PMBaseModelIdxContext *context = [self new];
    context.idx = idx;
    
    return context;
}

@end
