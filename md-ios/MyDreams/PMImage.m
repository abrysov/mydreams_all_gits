//
//  PMImage.m
//  MyDreams
//
//  Created by Иван Ушаков on 25.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMImage.h"

@implementation PMImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
             PMSelectorString(small): @"small",
             PMSelectorString(preMedium): @"pre_medium",
             PMSelectorString(medium): @"medium",
             PMSelectorString(large): @"large",
             };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
