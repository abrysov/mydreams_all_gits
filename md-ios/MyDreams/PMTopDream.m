//
//  PMTopDream.m
//  MyDreams
//
//  Created by user on 24.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTopDream.h"
#import "PMImage.h"

@implementation PMTopDream

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(title): @"title",
                              PMSelectorString(dreamDescription): @"description",
                              PMSelectorString(image): @"photo",
                              PMSelectorString(likesCount): @"likes_count",
                              PMSelectorString(commentsCount): @"comments_count",
                              PMSelectorString(likedByMe): @"liked_by_me"
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMImage class]];
}

@end
