//
//  PMDreambookBackgroundResponse.m
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookBackgroundResponse.h"

@implementation PMDreambookBackgroundResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(image): @"url",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMCroppedImage class]];
}

@end
