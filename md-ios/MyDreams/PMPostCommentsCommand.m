//
//  PMPostCommentsCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostCommentsCommand.h"

@implementation PMPostCommentsCommand

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx body:(NSString *)body
{
    self = [super init];
    if (self) {
        self.resourceType = resourceType;
        self.resourceIdx = resourceIdx;
        self.body = body;
    }
    
    return self;
}

- (NSString *)command
{
    return @"post";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"resource_type",
                              PMSelectorString(resourceIdx): @"resource_id",
                              PMSelectorString(body): @"body"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

@end
