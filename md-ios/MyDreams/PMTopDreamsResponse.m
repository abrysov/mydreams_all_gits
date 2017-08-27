//
//  PMTopDreamsResponse.m
//  MyDreams
//
//  Created by user on 24.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTopDreamsResponse.h"
#import "PMTopDream.h"

@implementation PMTopDreamsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(dreams): @"top_dreams",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMTopDream class]];
}

@end
