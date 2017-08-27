//
//  PMDetailedDreamViewModelImpl.m
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedDreamViewModelImpl.h"
#import <SORelativeDateTransformer/SORelativeDateTransformer.h>
#import "PMDream.h"
#import "PMDreamer.h"

@interface PMDetailedDreamViewModelImpl ()
@property (strong, nonatomic) NSString *dreamTitle;
@property (strong, nonatomic) NSString *dreamerTopInfo;
@property (strong, nonatomic) NSString *dreamerBottomInfo;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *descriptionCommentCount;
@property (strong, nonatomic) NSString *age;
@property (nonatomic, strong) UIImage *likesViewIcon;
@property (assign, nonatomic) BOOL isMine;
@end

@implementation PMDetailedDreamViewModelImpl

- (instancetype)initWithDream:(PMDream *)dream isMine:(BOOL)isMine
{
    self = [super init];
    if (self) {
        self.likedByMe = dream.likedByMe;
        
        RAC(self, likesViewIcon) = [RACObserve(self, likedByMe) map:^id(NSNumber *likedByMe) {
            return [likedByMe boolValue] ? [UIImage imageNamed:@"liked_fill_icon"] : [UIImage imageNamed:@"liked_icon"];
        }];
        
        self.age = [self ageFromBirthday:dream.dreamer.birthday];
        self.dreamTitle = dream.title;
        self.dreamerTopInfo = dream.dreamer.fullName;
        self.dreamerBottomInfo = [self dreamerDetailsFromDreamer:dream.dreamer];
        self.details = dream.details;
        self.date =  [[SORelativeDateTransformer registeredTransformer] transformedValue:dream.createdAt];
        self.likesCount = dream.likesCount;
        self.commentsCount = dream.commentsCount;
        self.descriptionCommentCount = [NSString stringWithFormat:@"%lu %@", (unsigned long)dream.commentsCount, NSLocalizedString(@"dreambook.detailed_dream.comments", nil)];
        self.isMine = isMine;
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
