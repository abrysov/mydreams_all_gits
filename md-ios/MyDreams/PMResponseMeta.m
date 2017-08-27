//
//  PMResponseMeta.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMResponseMeta.h"

@implementation PMResponseMeta

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             PMSelectorString(status): @"status",
             PMSelectorString(code): @"code",
             PMSelectorString(message): @"message",
             PMSelectorString(errors): @"errors",
             PMSelectorString(isBlocked): @"is_blocked",
             PMSelectorString(isDeleted): @"is_deleted"
             };
}

@end
