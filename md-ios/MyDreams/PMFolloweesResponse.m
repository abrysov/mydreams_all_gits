//
//  PMFolloweesResponse.m
//  MyDreams
//
//  Created by user on 29.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFolloweesResponse.h"
#import "PMDreamer.h"

@implementation PMFolloweesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dreamers): @"followees",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMDreamer class]];
}
@end
