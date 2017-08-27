//
//  PMFeedCommentsResponse.m
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFeedCommentsResponse.h"
#import "PMExtendedPost.h"

@implementation PMFeedCommentsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(comments): @"comments",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMExtendedPost class]];
}

@end
