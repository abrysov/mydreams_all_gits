//
//  PMMeResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerResponse.h"

@implementation PMDreamerResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dreamer): @"dreamer",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamerJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDreamer class]];
}

@end
