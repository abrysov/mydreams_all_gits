//
//  PMCertificates.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificate.h"
#import "NSValueTransformer+PM.h"

@implementation PMCertificate

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
                              PMSelectorString(accepted): @"accepted",
                              PMSelectorString(wish): @"wish",
                              PMSelectorString(launchesCount): @"launches",
                              PMSelectorString(certificateType): @"certificate_type_name",
                              PMSelectorString(certifiable): @"certifiable",
                              PMSelectorString(giftedBy): @"gifted_by",
							  PMSelectorString(createdAt): @"created_at"
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)certifiableJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDream class]];
}

+ (NSValueTransformer *)giftedByJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDreamer class]];
}

+ (NSValueTransformer *)certificateTypeJSONTransformer
{
    return [PMCertificateType certificateTypeValueTransformer];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
	return [NSValueTransformer createdAtAndupdatedAtTransformer];
}

@end
