//
//  PMCertificatesForm.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatesForm.h"

@implementation PMCertificatesForm

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(isGifted): @"gifted",
             PMSelectorString(isPaid): @"paid",
             PMSelectorString(isNew): @"new",
             PMSelectorString(isLaunches): @"launches",
             };
}

@end
