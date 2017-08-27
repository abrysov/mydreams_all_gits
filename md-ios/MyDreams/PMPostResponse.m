//
//  PMPostResponse.m
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostResponse.h"
#import "PMPost.h"

@implementation PMPostResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(post): @"post",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)postJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMPost class]];
}
@end
