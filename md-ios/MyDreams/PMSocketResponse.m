//
//  PMSocketResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSocketResponse.h"

@implementation PMSocketResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{PMSelectorString(type): @"type",
             PMSelectorString(command): @"command",
             PMSelectorString(replyTo): @"reply_to",
             PMSelectorString(payload): @"payload"};
}

@end
