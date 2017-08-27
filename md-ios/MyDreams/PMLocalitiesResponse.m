//
//  PMLocalityListResponse.m
//  MyDreams
//
//  Created by user on 04.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalitiesResponse.h"
#import "PMLocality.h"

@implementation PMLocalitiesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(localities): @"cities",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)localitiesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMLocality class]];
}

@end
