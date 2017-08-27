//
//  PMFeedsResponse.m
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFeedsResponse.h"

@implementation PMFeedsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(feeds): @"feeds",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)feedsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMPost class]];
}

@end
