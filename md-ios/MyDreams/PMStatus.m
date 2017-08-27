//
//  PMStatus.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMStatus.h"

@implementation PMStatus

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(coinsCount): @"coins_count",
                              PMSelectorString(messagesCount): @"messages_count",
                              PMSelectorString(notificationsCount): @"notifications_count",
                              PMSelectorString(friendRequestsCount): @"friend_requests_count",

                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
