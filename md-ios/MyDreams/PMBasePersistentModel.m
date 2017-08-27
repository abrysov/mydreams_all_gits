//
//  PMBasePersistentModel.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBasePersistentModel.h"

@implementation PMBasePersistentModel

- (BOOL)isPersisted
{
    return (self.idx != nil);
}

+ (NSString *)primaryKey
{
    return PMSelectorString(idx);
}

+ (NSArray RLM_GENERIC(NSString *) *)indexedProperties
{
    return @[PMSelectorString(idx)];
}

+ (NSDictionary *)JSONInboundMappingDictionary {
    return @{@"id": PMSelectorString(idx),
             @"retrieved_at": PMSelectorString(retrievedAt)
             };
}

+ (NSDictionary *)JSONOutboundMappingDictionary {
    return @{};
}

@end
