//
//  PMDreamersResponse.m
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamersResponse.h"
#import "PMDreamer.h"

@implementation PMDreamersResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dreamers): @"dreamers",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMDreamer class]];
}

@end
