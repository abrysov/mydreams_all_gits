//
//  PMDetailedPostPageViewModelImpl.m
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedPostPageViewModelImpl.h"
#import "PMPost.h"
#import <SORelativeDateTransformer/SORelativeDateTransformer.h>

@interface PMDetailedPostPageViewModelImpl ()
@property (strong, nonatomic) NSString *dreamerTopInfo;
@property (strong, nonatomic) NSString *dreamerBottomInfo;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *details;
@property (strong, nonatomic) NSString *descriptionCommentCount;
@property (strong, nonatomic) NSString *age;
@property (nonatomic, strong) UIImage *likesViewIcon;
@property (assign, nonatomic) BOOL isMine;
@end

@implementation PMDetailedPostPageViewModelImpl

- (instancetype)initWithPost:(PMPost *)post isMine:(BOOL)isMine
{
    self = [super init];
    if (self) {
        self.likedByMe = post.likedByMe;
        
        RAC(self, likesViewIcon) = [RACObserve(self, likedByMe) map:^id(NSNumber *likedByMe) {
            return [likedByMe boolValue] ? [UIImage imageNamed:@"post_like_fill_icon"] : [UIImage imageNamed:@"post_like_icon"];
        }];
        
        self.age = [self ageFromBirthday:post.dreamer.birthday];
        self.dreamerTopInfo = post.dreamer.fullName;
        self.dreamerBottomInfo = [self dreamerDetailsFromDreamer:post.dreamer];
        self.details = post.content;
        self.date =  [[SORelativeDateTransformer registeredTransformer] transformedValue:post.createdAt];
        self.likesCount = post.likesCount;
        self.commentsCount = post.commentsCount;
        self.descriptionCommentCount = [NSString stringWithFormat:@"%lu %@", (unsigned long)post.commentsCount, NSLocalizedString(@"dreambook.detailed_post.comments", nil)];
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
