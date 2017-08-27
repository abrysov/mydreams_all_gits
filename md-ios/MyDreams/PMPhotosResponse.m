//
//  PMPhotoResponse.m
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotosResponse.h"
#import "PMPhoto.h"

@implementation PMPhotosResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(photos): @"photos",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMPhoto class]];
}

@end
