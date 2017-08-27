//
//  PMPersistentMe.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPersistentMe.h"
#import <Mantle/Mantle.h>
#import "PMDreamer.h"
#import "PMStatus.h"


@implementation PMPersistentMe

+ (NSArray *)indexedProperties
{
    return @[PMSelectorString(idx)];
}

+ (NSString *)primaryKey
{
    return PMSelectorString(idx);
}

+ (NSValueTransformer *)genderValueTransformer
{
    static NSValueTransformer *transformer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transformer = [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                                      @"unknow": @(PMDreamerGenderUnknow),
                                                                                      @"male": @(PMDreamerGenderMale),
                                                                                      @"female": @(PMDreamerGenderFemale)
                                                                                      }
                                                                       defaultValue:@(PMDreamerGenderUnknow)
                                                                reverseDefaultValue:@"unknow"];
    });
    
    return transformer;
}

- (instancetype)initWithDreamer:(PMDreamer *)dreamer status:(PMStatus *)status
{
    self = [super init];
    if (self) {
        self.idx = dreamer.idx;
        self.fullName = dreamer.fullName;
        self.gender = [self genderToString:dreamer.gender];
        self.isVip = dreamer.isVip;
        self.isCelebrity = dreamer.isCelebrity;
        self.cityIdx = dreamer.city.idx;
        self.city = dreamer.city.name;
        self.countryIdx = dreamer.country.idx;
        self.country = dreamer.country.name;
        self.visitsCount = dreamer.visitsCount;
        self.firstName = dreamer.firstName;
        self.lastName = dreamer.lastName;
        self.birthday = dreamer.birthday;
        self.status = dreamer.status;
        self.viewsCount = @(dreamer.viewsCount);
        self.friendsCount = @(dreamer.friendsCount);
        self.dreamsCount = @(dreamer.dreamsCount);
        self.fullfiledDreamsCount = @(dreamer.fullfiledDreamsCount);
        self.isBlocked = dreamer.isBlocked;
        self.isDeleted = dreamer.isDeleted;
        self.launchesCount = @(dreamer.launchesCount);
        self.isOnline = dreamer.isOnline;
        self.token = dreamer.token;
        
        self.avatar = [[PMPersistentAvatar alloc] initWithImage:dreamer.avatar];
        
        self.coinsCount = @(status.coinsCount);
        self.messagesCount = @(status.messagesCount);
        self.notificationsCount = @(status.notificationsCount);
        self.friendRequestsCount = @(status.friendRequestsCount);
    }
    return self;
}

- (PMDreamer *)toDreamer
{
    PMDreamer *dreamer = [[PMDreamer alloc] init];
    [dreamer setValue:self.idx forKey:PMSelectorString(idx)];
    [dreamer setValue:self.fullName forKey:PMSelectorString(fullName)];
    [dreamer setValue:[self genderFromString:self.gender] forKey:PMSelectorString(gender)];
    [dreamer setValue:self.isVip forKey:PMSelectorString(isVip)];
    [dreamer setValue:self.isCelebrity forKey:PMSelectorString(isCelebrity)];
    [dreamer setValue:self.visitsCount forKey:PMSelectorString(visitsCount)];
    [dreamer setValue:self.firstName forKey:PMSelectorString(firstName)];
    [dreamer setValue:self.lastName forKey:PMSelectorString(lastName)];
    [dreamer setValue:self.birthday forKey:PMSelectorString(birthday)];
    [dreamer setValue:self.status forKey:PMSelectorString(status)];
    [dreamer setValue:self.viewsCount forKey:PMSelectorString(viewsCount)];
    [dreamer setValue:self.friendsCount forKey:PMSelectorString(friendsCount)];
    [dreamer setValue:self.dreamsCount forKey:PMSelectorString(dreamsCount)];
    [dreamer setValue:self.fullfiledDreamsCount forKey:PMSelectorString(fullfiledDreamsCount)];
    [dreamer setValue:self.isBlocked forKey:PMSelectorString(isBlocked)];
    [dreamer setValue:self.isDeleted forKey:PMSelectorString(isDeleted)];
    [dreamer setValue:self.launchesCount forKey:PMSelectorString(launchesCount)];
    [dreamer setValue:self.isOnline forKey:PMSelectorString(isOnline)];
    [dreamer setValue:self.token forKey:PMSelectorString(token)];
    [dreamer setValue:[self.avatar toImage] forKey:PMSelectorString(avatar)];
    
    if (self.countryIdx) {
        [dreamer setValue:[[PMLocation alloc] init] forKey:PMSelectorString(country)];
        [dreamer.country setValue:self.country forKey:PMSelectorString(name)];
        [dreamer.country setValue:self.countryIdx forKey:PMSelectorString(idx)];
    }
    
    if (self.cityIdx) {
        [dreamer setValue:[[PMLocation alloc] init] forKey:PMSelectorString(city)];
        [dreamer.city setValue:self.city forKey:PMSelectorString(name)];
        [dreamer.city setValue:self.cityIdx forKey:PMSelectorString(idx)];
    }
    
    return dreamer;
}

- (PMStatus *)toStatus
{
    PMStatus *status = [[PMStatus alloc] init];
    [status setValue:self.coinsCount forKey:PMSelectorString(coinsCount)];
    [status setValue:self.messagesCount forKey:PMSelectorString(messagesCount)];
    [status setValue:self.notificationsCount forKey:PMSelectorString(notificationsCount)];
    [status setValue:self.friendRequestsCount forKey:PMSelectorString(friendRequestsCount)];
    return status;
}

- (NSString *)genderToString:(PMDreamerGender)gender
{
    return [[self.class genderValueTransformer] reverseTransformedValue:@(gender)];
}

- (NSNumber *)genderFromString:(NSString *)gender
{
    return [[self.class genderValueTransformer] transformedValue:gender];
}

@end
