//
//  PMPostPhoto.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostPhoto.h"
#import "PMImage.h"

@implementation PMPostPhoto

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(photo): @"photo",
                              PMSelectorString(postIdx): @"post_id",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)photoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMImage class]];
}

@end
