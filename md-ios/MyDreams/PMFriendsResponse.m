//
//  PMFriendsResponse.m
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendsResponse.h"
#import "PMDreamer.h"

@implementation PMFriendsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(friends): @"friends",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)friendsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMDreamer class]];
}

@end
