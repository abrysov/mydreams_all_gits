//
//  PMDreamsResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamsResponse.h"
#import "PMDream.h"

@implementation PMDreamsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dreams): @"dreams",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMDream class]];
}

@end
