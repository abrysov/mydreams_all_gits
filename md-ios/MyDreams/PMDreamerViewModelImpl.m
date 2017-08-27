//
//  PMDreamerViewModelImpl.m
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerViewModelImpl.h"
#import "PMDreamer.h"

@interface PMDreamerViewModelImpl ()
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *dreamerDetails;
@property (strong, nonatomic) UIImage *genderImage;
@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) BOOL isOnline;
@end

@implementation PMDreamerViewModelImpl

- (instancetype)initWithDreamer:(PMDreamer *)dreamer
{
    self = [super init];
    if (self) {
        self.dreamerIdx = dreamer.idx;
        self.fullName = dreamer.fullName;
        self.dreamerDetails = [self dreamerDetailsFromDreamer:dreamer];
        
        NSString *genderImageName = dreamer.gender == PMDreamerGenderFemale ? @"gender_woman_icon" : @"gender_man_icon";
        self.genderImage = [UIImage imageNamed:genderImageName];
        
        self.isVip = [dreamer.isVip boolValue];
        self.isOnline = [dreamer.isOnline boolValue];
        
        if ([dreamer.isFriend boolValue]) {
            self.subscriptionType = PMDreamerSubscriptionTypeFriend;
        }
        else if ([dreamer.isFollower boolValue]) {
            self.subscriptionType = PMDreamerSubscriptionTypeSubscriber;
        }
        else {
            self.subscriptionType = PMDreamerSubscriptionTypeNope;
        }
    }
    return self;
}

- (NSString *)dreamerDetailsFromDreamer:(PMDreamer *)dreamer
{
    NSString *result = @"";
    result = [self stringFromString:result byAppendingComponent:[self ageFromBirthday:dreamer.birthday]];
    result = [self stringFromString:result byAppendingComponent:dreamer.country.name];
    result = [self stringFromString:result byAppendingComponent:dreamer.city.name];
    return result;
}

- (NSString *)stringFromString:(NSString *)string byAppendingComponent:(NSString *)componnet
{
    if (componnet && ![componnet isEqual:[NSNull null]]) {
        if (string.length > 0) {
            string = [string stringByAppendingString:@", "];
        }
        string = [string stringByAppendingString:componnet];
    }
    
    return string;
}

- (NSString *)ageFromBirthday:(NSDate *)birthday;
{
    if (!birthday) {
        return nil;
    }
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:birthday
                                       toDate:now
                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    return [NSString stringWithFormat:@"%lu", (long)age];
}

@end
