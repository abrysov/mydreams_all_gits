//
//  PMCountries.m
//  MyDreams
//
//  Created by user on 04.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocation.h"

@implementation PMLocation

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
             PMSelectorString(name): @"name",
             };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
