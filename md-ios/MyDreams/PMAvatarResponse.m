//
//  PMAvatarResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 10.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAvatarResponse.h"
#import "PMImage.h"

@implementation PMAvatarResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(avatar): @"avatar",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)dreamersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMImage class]];
}


@end
