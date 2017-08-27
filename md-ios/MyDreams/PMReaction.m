//
//  PMReaction.m
//  MyDreams
//
//  Created by Иван Ушаков on 27.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMReaction.h"

@implementation PMReaction

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"reactable_type",
                              PMSelectorString(resourceIdx): @"reactable_id",
                              PMSelectorString(reaction): @"reaction",
                              PMSelectorString(dreamerFirstName): @"dreamer_first_name",
                              PMSelectorString(dreamerLastName): @"dreamer_last_name",
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

@end
