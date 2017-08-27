//
//  PMPostViewModelImpl.m
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostViewModelImpl.h"
#import "PMPost.h"
#import <SORelativeDateTransformer/SORelativeDateTransformer.h>

@interface PMPostViewModelImpl ()
@property (strong, nonatomic) NSNumber *postIdx;
@property (strong, nonatomic) NSString *fullNameAndAge;
@property (strong, nonatomic) NSString *dreamerLocation;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *details;
@property (assign, nonatomic) NSUInteger likeCount;
@property (assign, nonatomic) NSUInteger commentsCount;
@property (assign, nonatomic) BOOL likedByMe;
@end

@implementation PMPostViewModelImpl

- (instancetype)initWithPost:(PMPost *)post
{
    self = [super init];
    if (self) {
        self.postIdx = post.idx;
        self.fullNameAndAge = [self fullNameAndAgeFromDreamer:post.dreamer];
        self.dreamerLocation = [self dreamerLocationFromDreamer:post.dreamer];
        self.details = post.content;
        self.date =  [[SORelativeDateTransformer registeredTransformer] transformedValue:post.createdAt];
        self.likeCount = post.likesCount;
        self.commentsCount = post.commentsCount;
        self.likedByMe = post.likedByMe;
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
