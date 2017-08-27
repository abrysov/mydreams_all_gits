//
//  PMLikesResponse.m
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLikesResponse.h"
#import "PMLike.h"

@implementation PMLikesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(likes): @"likes",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)likesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMLike class]];
}

@end
