//
//  PMBaseModelIdxWithIsMineContext.m
//  MyDreams
//
//  Created by user on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModelIdxWithIsMineContext.h"

@implementation PMBaseModelIdxWithIsMineContext

+ (PMBaseModelIdxWithIsMineContext *)contextWithIdx:(NSNumber *)idx isMine:(BOOL)isMine
{
    PMBaseModelIdxWithIsMineContext *context = [self new];
    context.idx = idx;
    context.isMine = isMine;
    return context;
}

@end
