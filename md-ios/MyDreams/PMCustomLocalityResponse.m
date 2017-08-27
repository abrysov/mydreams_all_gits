//
//  PMLocalityIdResponse.m
//  MyDreams
//
//  Created by user on 12.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCustomLocalityResponse.h"

@implementation PMCustomLocalityResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(locality): @"city",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)localityJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMLocality class]];
}

@end
