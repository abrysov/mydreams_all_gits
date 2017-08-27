//
//  PMDetailedLikesContext.h
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModelIdxContext.h"
#import "PMEntityType.h"

@interface PMDetailedLikesContext : PMBaseModelIdxContext
@property (nonatomic, assign) PMEntityType type;
+ (instancetype)contextWithIdx:(NSNumber *)idx andType:(PMEntityType)type;
@end
