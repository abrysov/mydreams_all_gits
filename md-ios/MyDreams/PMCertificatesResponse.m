//
//  PMCertificatesResponse.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatesResponse.h"
#import "PMCertificate.h"

@implementation PMCertificatesResponse

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(certificates): @"certificates",
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)certificatesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PMCertificate class]];
}

@end
