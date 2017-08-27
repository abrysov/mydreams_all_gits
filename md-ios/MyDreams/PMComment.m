//
//  PMComment.m
//  MyDreams
//
//  Created by Иван Ушаков on 27.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMComment.h"
#import "PMReaction.h"
#import "NSValueTransformer+PM.h"
#import "PMDreamer.h"

@implementation PMComment

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(resourceType): @"resource_type",
                              PMSelectorString(resourceIdx): @"resource_id",
                              PMSelectorString(body): @"body",
                              PMSelectorString(dreamerFirstName): @"dreamer_first_name",
                              PMSelectorString(dreamerLastName): @"dreamer_last_name",
                              PMSelectorString(dreamerAge): @"dreamer_age",
                              PMSelectorString(dreamerAvatar): @"dreamer_avatar",
                              PMSelectorString(dreamerGender): @"dreamer_gender",
                              PMSelectorString(dreamerIdx): @"dreamer_id",
                              PMSelectorString(reactions): @"reactions",
                              PMSelectorString(createdAt): @"created_at",
                              PMSelectorString(dreamer): @"dreamer"
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)resourceTypeJSONTransformer
{
    return [PMEntityTypeConverter transformer];
}

+ (NSValueTransformer *)dreamerGenderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"male": @(PMDreamerGenderMale),
        @"female": @(PMDreamerGenderFemale)
    } defaultValue:@(PMDreamerGenderUnknow) reverseDefaultValue:[NSNull null]];
}

+ (NSValueTransformer *)reactionsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMReaction class]];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [NSValueTransformer createdAtAndupdatedAtTransformer];
}

+ (NSValueTransformer *)dreamerJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDreamer class]];
}

@end
