//
//  PMFriendshipRequestsResponse.m
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestsResponse.h"
#import "PMFriendshipRequest.h"

@implementation PMFriendshipRequestsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(friendshipRequests): @"friendship_requests",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)friendshipRequestsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMFriendshipRequest class]];
}

@end