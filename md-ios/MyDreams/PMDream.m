//
//  PMDream.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDream.h"
#import "PMImage.h"
#import "PMDreamer.h"
#import "NSValueTransformer+PM.h"

@implementation PMDream

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(certificateType): @"certificate_type",
                              PMSelectorString(fulfilled): @"fulfilled",
                              PMSelectorString(likedByMe): @"liked_by_me",
                              PMSelectorString(likesCount): @"likes_count",
                              PMSelectorString(commentsCount): @"comments_count",
                              PMSelectorString(launchesCount): @"launches_count",
                              PMSelectorString(createdAt): @"created_at",
                              PMSelectorString(title): @"title",
                              PMSelectorString(details): @"description",
                              PMSelectorString(image): @"photo",
                              PMSelectorString(dreamer): @"dreamer",
                              PMSelectorString(restrictionLevel): @"restriction_level"
                              };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)imageJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMImage class]];
}

+ (NSValueTransformer *)dreamerJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMDreamer class]];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [NSValueTransformer createdAtAndupdatedAtTransformer];
}

+ (NSValueTransformer *)certificateTypeJSONTransformer
{
    return [PMCertificateType certificateTypeValueTransformer];
}

- (NSString *)certificateTypeString
{
    return [[PMCertificateType certificateTypeValueTransformer] reverseTransformedValue:@(self.certificateType)];
}

+ (NSValueTransformer *)restrictionLevelJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"private": @(PMDreamRestrictionLevelPrivate),
                                                                           @"public": @(PMDreamRestrictionLevelPublic),
                                                                           @"friends": @(PMDreamRestrictionLevelFriends),
                                                                           } defaultValue:PMDreamRestrictionLevelPublic reverseDefaultValue:[NSNull null]];
}

@end
