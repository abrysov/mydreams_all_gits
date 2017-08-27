//
//  PMPostComment.m
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMExtendedPost.h"
#import "PMComment.h"
#import "PMLike.h"

@implementation PMExtendedPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(lastComments): @"last_comments",
                              PMSelectorString(lastLikes) : @"last_likes"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)lastCommentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMComment class]];
}

+ (NSValueTransformer *)lastLikesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMLike class]];
}

@end
