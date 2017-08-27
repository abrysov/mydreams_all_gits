//
//  PMFeedRecommendationsResponse.m
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFeedRecommendationsResponse.h"
#import "PMExtendedPost.h"

@implementation PMFeedRecommendationsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(recommendations): @"recommendations",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)recommendationsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMExtendedPost class]];
}

@end
