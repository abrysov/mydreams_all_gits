//
//  PMDreamFilterForm.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamFilterForm.h"

@implementation PMDreamFilterForm

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(search): @"search",
             PMSelectorString(gender): @"gender",
             PMSelectorString(isFulfilled): @"fulfilled",
             PMSelectorString(isNew): @"new",
             PMSelectorString(isHot): @"hot",
             PMSelectorString(isLiked): @"liked",
            };
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"male": @(PMDreamerGenderMale),
                                                                           @"female": @(PMDreamerGenderFemale)
                                                                           } defaultValue:PMDreamerGenderUnknow reverseDefaultValue:[NSNull null]];
}

@end
