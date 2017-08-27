//
//  PMListCommentsCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListCommentsCommand.h"
#import "PMPage.h"

@implementation PMListCommentsCommand

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx page:(PMPage *)page
{
    self = [super init];
    if (self) {
        self.resourceType = resourceType;
        self.resourceIdx = resourceIdx;
        self.sinceId = page.from ?: @(0);
        self.count = page.per;
    }
    
    return self;
}

- (NSString *)command
{
    return @"list";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"resource_type",
                              PMSelectorString(resourceIdx): @"resource_id",
                              PMSelectorString(sinceId): @"since_id",
                              PMSelectorString(count): @"count"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

@end
