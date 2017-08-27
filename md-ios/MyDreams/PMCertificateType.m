//
//  PMCertificateType.m
//  MyDreams
//
//  Created by user on 13.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "PMCertificateType.h"

@implementation PMCertificateType

+ (NSValueTransformer *)certificateTypeValueTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"My Dreams": @(PMDreamCertificateTypeMyDreams),
                                                                           @"Bronze": @(PMDreamCertificateTypeBronze),
                                                                           @"Silver": @(PMDreamCertificateTypeSilver),
                                                                           @"Gold": @(PMDreamCertificateTypeGold),
                                                                           @"Platinum": @(PMDreamCertificateTypePlatinum),
                                                                           @"VIP": @(PMDreamCertificateTypeVIP),
                                                                           @"Presidential": @(PMDreamCertificateTypePresidential),
                                                                           @"Imperial": @(PMDreamCertificateTypeImperial),
                                                                           } defaultValue:@(PMDreamCertificateTypeUnknown) reverseDefaultValue:[NSNull null]];
}

@end