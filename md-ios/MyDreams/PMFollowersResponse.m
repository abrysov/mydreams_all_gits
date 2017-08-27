//
//  PMFollowersResponse.m
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFollowersResponse.h"
#import "PMDreamer.h"

@implementation PMFollowersResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(followers): @"followers",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)followersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMDreamer class]];
}

@end
