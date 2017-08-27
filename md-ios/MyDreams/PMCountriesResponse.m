//
//  PMContriesResponse.m
//  MyDreams
//
//  Created by user on 04.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCountriesResponse.h"

@implementation PMCountriesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(countries): @"countries",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)countriesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMLocation class]];
}

@end
