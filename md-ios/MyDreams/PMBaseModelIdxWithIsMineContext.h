//
//  PMBaseModelIdxWithIsMineContext.h
//  MyDreams
//
//  Created by user on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@interface PMBaseModelIdxWithIsMineContext : PMBaseContext
@property (strong, nonatomic) NSNumber *idx;
@property (assign, nonatomic) BOOL isMine;
+ (PMBaseModelIdxWithIsMineContext *)contextWithIdx:(NSNumber *)idx isMine:(BOOL)isMine;
@end
