//
//  PMFriendshipRequestResponse.m
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestResponse.h"

@implementation PMFriendshipRequestResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(friendshipRequest): @"friendship_request",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)friendshipRequestsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMFriendshipRequest class]];
}

@end
