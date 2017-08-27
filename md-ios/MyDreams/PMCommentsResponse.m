//
//  PMCommentsResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCommentsResponse.h"
#import "PMComment.h"

@implementation PMCommentsResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"resource_type",
                              PMSelectorString(resourceIdx): @"resource_id",
                              PMSelectorString(sinceId): @"since_id",
                              PMSelectorString(comments): @"comments"};
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)commentsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMComment class]];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

@end
