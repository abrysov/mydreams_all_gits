//
//  PMBaseModelIdxContext.h
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@interface PMBaseModelIdxContext : PMBaseContext
@property (strong, nonatomic) NSNumber *idx;
+ (PMBaseModelIdxContext *)contextWithIdx:(NSNumber *)idx;
@end
