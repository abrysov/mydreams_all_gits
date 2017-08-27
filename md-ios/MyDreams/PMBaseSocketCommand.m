//
//  PMBaseSocketMessage.m
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketCommand.h"

@implementation PMBaseSocketCommand

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{PMSelectorString(type): @"type",
             PMSelectorString(command): @"command",
             PMSelectorString(idx): @"id"};
}

@end
