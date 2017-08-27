//
//  PMPhotoResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotoResponse.h"
#import "PMPhoto.h"

@implementation PMPhotoResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(photo): @"photo",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)photosJSONTransformer
{
    return [MTLJSONAdapter transformerForModelPropertiesOfClass:[PMPhoto class]];
}

@end
