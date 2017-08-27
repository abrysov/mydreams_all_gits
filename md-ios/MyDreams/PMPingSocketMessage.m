
//
//  PMPingSocketMessage.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPingSocketMessage.h"

@implementation PMPingSocketMessage

- (NSString *)type
{
    return @"ping";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(type): @"type"};
}

@end
