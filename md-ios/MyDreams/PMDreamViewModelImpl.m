//
//  PMDreamViewModel.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamViewModelImpl.h"
#import "PMDream.h"
#import "PMDreamer.h"
#import "PMTopDream.h"
#import <SORelativeDateTransformer/SORelativeDateTransformer.h>
#import "UIColor+MyDreams.h"

@interface PMDreamViewModelImpl ()
@property (strong, nonatomic) NSNumber *dreamIdx;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *dreamerDetails;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *certificateType;

@property (strong, nonatomic) UIImage *genderImage;

@property (strong, nonatomic) NSString *titile;
@property (strong, nonatomic) NSString *details;

@property (assign, nonatomic) NSUInteger likeCount;
@property (assign, nonatomic) NSUInteger commentsCount;
@property (assign, nonatomic) NSUInteger lounchCount;

@property (strong, nonatomic) UIColor *color;

@property (assign, nonatomic) BOOL likedByMe;
@property (strong, nonatomic) NSString *positionString;
@end


@implementation PMDreamViewModelImpl

- (instancetype)initWithDream:(PMDream *)dream
{
    self = [super init];
    if (self) {
        self.dreamIdx = dream.idx;
        self.fullName = dream.dreamer.fullName;
        self.dreamerDetails = [self dreamerDetailsFromDreamer:dream.dreamer];
        self.certificateType = dream.certificateTypeString;
        
        NSString *genderImageName = dream.dreamer.gender == PMDreamerGenderFemale ? @"gender_woman_icon" : @"gender_man_icon";
        self.genderImage = [UIImage imageNamed:genderImageName];
        
        self.color = [self colorForCertificateType:dream.certificateType];
        
        self.titile = dream.title;
        self.details = dream.details;
        self.date =  [[SORelativeDateTransformer registeredTransformer] transformedValue:dream.createdAt];
        
        self.likeCount = dream.likesCount;
        self.commentsCount = dream.commentsCount;
        self.lounchCount = dream.launchesCount;
        
        self.likedByMe = dream.likedByMe;
    }
    
    return self;
}

- (instancetype)initWithTopDream:(PMTopDream *)dream
{
    self = [super init];
    if (self) {
        self.dreamIdx = dream.idx;
        self.titile = dream.title;
        self.details = dream.dreamDescription;
        self.likeCount = dream.likesCount;
        self.commentsCount = dream.commentsCount;
        self.likedByMe = dream.likedByMe;
    }
    return self;
}

- (void)setPosition:(NSUInteger)position
{
    self->_position = position;
    self.positionString = [NSString stringWithFormat:@"%lu", (unsigned long)position];
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

- (UIColor *)colorForCertificateType:(PMDreamCertificateType)certificateType
{
    switch (certificateType) {
        case PMDreamCertificateTypeBronze:
            return [UIColor bronzeDreamColor];
        case PMDreamCertificateTypeGold:
            return [UIColor goldDreamColor];
        case PMDreamCertificateTypeVIP:
            return [UIColor vipDreamColor];
        case PMDreamCertificateTypeImperial:
            return [UIColor imperialDreamColor];
        case PMDreamCertificateTypePlatinum:
            return [UIColor platinumDreamColor];
        case PMDreamCertificateTypePresidential:
            return [UIColor presidentialDreamColor];
        case PMDreamCertificateTypeSilver:
            return [UIColor silverDreamColor];
        case PMDreamCertificateTypeUnknown:
        case PMDreamCertificateTypeMyDreams:
            return [UIColor myDreamsDreamColor];
    }
}

@end
