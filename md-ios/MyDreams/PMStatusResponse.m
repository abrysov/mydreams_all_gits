//
//  PMStatusResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMStatusResponse.h"

@implementation PMStatusResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(status): @"dreamer",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)statusJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMStatus class]];
}

@end
