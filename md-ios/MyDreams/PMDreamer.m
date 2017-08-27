//
//  PMDreamer.m
//  MyDreams
//
//  Created by Иван Ушаков on 24.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamer.h"

@implementation PMDreamer

+ (NSDateFormatter *)birthdayDateFormatter
{
    static NSDateFormatter *birthdayDateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        birthdayDateFormatter = [[NSDateFormatter alloc] init];
        birthdayDateFormatter.dateFormat = @"YYYY-MM-DD";
    });
    return birthdayDateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{
             PMSelectorString(idx): @"id",
             PMSelectorString(fullName): @"full_name",
             PMSelectorString(gender): @"gender",
             PMSelectorString(isVip): @"vip",
             PMSelectorString(isCelebrity): @"celebrity",
             PMSelectorString(city): @"city",
             PMSelectorString(country): @"country",
             PMSelectorString(visitsCount): @"visits_count",
             PMSelectorString(firstName): @"first_name",
             PMSelectorString(lastName): @"last_name",
             PMSelectorString(birthday): @"birthday",
             PMSelectorString(status): @"status",
             PMSelectorString(viewsCount): @"views_count",
             PMSelectorString(friendsCount): @"friends_count",
             PMSelectorString(dreamsCount): @"dreams_count",
             PMSelectorString(fullfiledDreamsCount): @"fulfilled_dreams_count",
             PMSelectorString(followeesCount): @"followees_count",
             PMSelectorString(followersCount): @"followers_count",
             PMSelectorString(isBlocked): @"is_blocked",
             PMSelectorString(isDeleted): @"is_deleted",
             PMSelectorString(launchesCount): @"launches_count",
             PMSelectorString(photosCount): @"photos_count",
             PMSelectorString(email): @"email",
             PMSelectorString(isOnline): @"is_online",
             PMSelectorString(avatar): @"avatar",
             PMSelectorString(dreambookBackground): @"dreambook_bg",
             PMSelectorString(isFriend): @"i_friend",
             PMSelectorString(isFollower): @"i_follower",
             PMSelectorString(url): @"url",
             PMSelectorString(token): @"token"
             };
    
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

+ (NSValueTransformer *)genderJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"male": @(PMDreamerGenderMale),
        @"female": @(PMDreamerGenderFemale)
    } defaultValue:@(PMDreamerGenderUnknow) reverseDefaultValue:[NSNull null]];
}

+ (NSValueTransformer *)avatarJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMImage class]];
}

+ (NSValueTransformer *)dreambookBackgroundJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMCroppedImage class]];
}

+ (NSValueTransformer *)cityJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMLocation class]];
}

+ (NSValueTransformer *)countryJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMLocation class]];
}

+ (NSValueTransformer *)birthdayJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSDateFormatter *formatter = [self birthdayDateFormatter];
        *success = YES;
        return [formatter dateFromString:value];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSDateFormatter *formatter = [self birthdayDateFormatter];
        *success = YES;
        return [formatter stringFromDate:value];
    }];
}

@end
