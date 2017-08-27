//
//  PMPost.m
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPost.h"
#import "PMPostPhoto.h"
#import "PMDreamer.h"
#import "NSValueTransformer+PM.h"

@implementation PMPost

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(content): @"content",
                              PMSelectorString(photos): @"photos",
                              PMSelectorString(likesCount): @"likes_count",
                              PMSelectorString(commentsCount): @"comments_count",
                              PMSelectorString(restrictionLevel): @"restriction_level",
                              PMSelectorString(dreamer): @"dreamer",
                              PMSelectorString(likedByMe): @"liked_by_me",
                              PMSelectorString(createdAt): @"created_at"
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [NSValueTransformer createdAtAndupdatedAtTransformer];
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMPostPhoto class]];
}

+ (NSValueTransformer *)dreamerJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDreamer class]];
}

+ (NSValueTransformer *)restrictionLevelJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"private": @(PMDreamRestrictionLevelPrivate),
                                                                           @"public": @(PMDreamRestrictionLevelPublic),
                                                                           @"friends": @(PMDreamRestrictionLevelFriends),
                                                                           } defaultValue:PMDreamRestrictionLevelPublic reverseDefaultValue:[NSNull null]];
}

@end
