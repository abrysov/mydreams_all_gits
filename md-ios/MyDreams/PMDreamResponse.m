//
//  PMDreamResponse.m
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamResponse.h"

@implementation PMDreamResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dream): @"dream",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDream class]];
}

@end
