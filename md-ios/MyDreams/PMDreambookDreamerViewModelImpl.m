//
//  PMFollowerViewModelImpl.m
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookDreamerViewModelImpl.h"

@interface PMDreambookDreamerViewModelImpl ()
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (strong, nonatomic) NSString *topInfo;
@property (strong, nonatomic) NSString *bottomInfo;
@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) BOOL isOnline;
@property (assign, nonatomic) BOOL isNew;
@end

@implementation PMDreambookDreamerViewModelImpl

- (instancetype)initWithDreamer:(PMDreamer *)dreamer
{
    self = [super init];
    if (self) {
        self.dreamerIdx = dreamer.idx;
        self.topInfo = [self fullNameAndAgeFromDreamer:dreamer];
        self.bottomInfo = [self dreamerLocationFromDreamer:dreamer];
        self.isVip = [dreamer.isVip boolValue];
        self.isOnline = [dreamer.isOnline boolValue];
    }
    return self;
}

- (NSString *)fullNameAndAgeFromDreamer:(PMDreamer *)dreamer
{
    NSString *result = @"";
    result = [self stringFromString:result byAppendingComponent:dreamer.fullName];
    result = [self stringFromString:result byAppendingComponent:[self ageFromBirthday:dreamer.birthday]];
    return result;
}

- (NSString *)dreamerLocationFromDreamer:(PMDreamer *)dreamer
{
    NSString *result = @"";
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
