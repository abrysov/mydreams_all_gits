//
//  PMEntityType.m
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEntityType.h"
#import <Mantle/Mantle.h>

@implementation PMEntityTypeConverter

+ (NSDictionary  *)mapping
{
    static NSDictionary *mapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = @{@"dream": @(PMEntityTypeDream),
                    @"top_dream": @(PMEntityTypeTopDream),
                    @"post": @(PMEntityTypePost),
                    @"photo": @(PMEntityTypePhoto)
                    };
    });
    
    return mapping;
}

+ (NSValueTransformer *)transformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:[self mapping] defaultValue:@(PMEntityTypeUnknown) reverseDefaultValue:[NSNull null]];
}

+ (NSString *)entityTypeToString:(PMEntityType)entityType
{
    return [[[self mapping] allKeysForObject:@(entityType)] firstObject];
}

+ (PMEntityType)stringToEntityType:(NSString *)string
{
    return [[[self mapping] objectForKey:string] unsignedIntegerValue];
}

@end
