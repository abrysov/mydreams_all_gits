//
//  PMDreamerFilterForm.m
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerFilterForm.h"

@implementation PMDreamerFilterForm

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(search): @"search",
             PMSelectorString(ageFrom):@"age[from]",
             PMSelectorString(ageTo):@"age[to]",
             PMSelectorString(gender): @"gender",
             PMSelectorString(isOnline): @"online",
             PMSelectorString(isNew): @"new",
             PMSelectorString(isTop): @"top",
             PMSelectorString(isVip): @"vip",
             PMSelectorString(cityId): @"city_id",
             PMSelectorString(countryId): @"country_id",
             };
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"male": @(PMDreamerGenderMale),
                                                                           @"female": @(PMDreamerGenderFemale)
                                                                           } defaultValue:PMDreamerGenderUnknow reverseDefaultValue:[NSNull null]];
}

@end
