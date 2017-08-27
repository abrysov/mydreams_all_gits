//
//  PMPostPhotoResponse.m
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostPhotoResponse.h"

@implementation PMPostPhotoResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(postPhoto): @"post_photo",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)postPhotoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMPostPhoto class]];
}

@end
