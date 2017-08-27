//
//  PMUnsubscribeCommentsCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUnsubscribeCommentsCommand.h"

@implementation PMUnsubscribeCommentsCommand

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx
{
    self = [super init];
    if (self) {
        self.resourceType = resourceType;
        self.resourceIdx = resourceIdx;
    }
    
    return self;
}

- (NSString *)command
{
    return @"unsubscribe";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"resource_type",
                              PMSelectorString(resourceIdx): @"resource_id",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

@end
