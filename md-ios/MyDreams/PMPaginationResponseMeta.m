//
//  PMPaginationResponseMeta.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponseMeta.h"

@implementation PMPaginationResponseMeta

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
             PMSelectorString(per): @"per",
             PMSelectorString(page): @"page",
             PMSelectorString(totalCount): @"total_count",
             PMSelectorString(pagesCount): @"pages_count",
             PMSelectorString(remainingCount): @"remaining_count",
             };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
