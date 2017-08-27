//
//  PMMyDreambookViewModelImpl.m
//  MyDreams
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookHeaderViewModelImpl.h"
#import "PMDreamer.h"

@interface PMDreambookHeaderViewModelImpl ()

@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *detailsDreamer;
@property (assign, nonatomic) NSUInteger photosCount;
@property (assign, nonatomic) NSUInteger dreamsCount;
@property (assign, nonatomic) NSUInteger completedCount;
@property (assign, nonatomic) NSUInteger marksCount;
@property (assign, nonatomic) NSUInteger friendsCount;
@property (assign, nonatomic) NSUInteger subscribersCount;
@property (assign, nonatomic) NSUInteger subscriptionsCount;
@property (assign, nonatomic) NSInteger marksBadgeValue;
@property (assign, nonatomic) PMDreamerStatus statusDreamer;
@property (strong, nonatomic) UIImage *genderImage;
@property (strong, nonatomic) UIImage *defaultPhoto;
@property (assign, nonatomic) BOOL isOnline;
@property (strong, nonatomic) UIImage *notAvailableImage;
@property (strong, nonatomic) NSString *dreamerStateMessage;
@property (assign, nonatomic) PMDreamerAccessState accessState;
@property (strong, nonatomic) NSURL *dreambookUrl;
@property (strong, nonatomic) NSURL *baseUrl;
@property (strong, nonatomic) NSString *postsCount;
@end

@implementation PMDreambookHeaderViewModelImpl

- (instancetype)initWithBaseUrl:(NSURL *)baseUrl;
{
    self = [super init];
    if (self) {
        self.baseUrl = baseUrl;
    }
    
    return self;
}

- (void)setDreamer:(PMDreamer *)dreamer
{
    self->_dreamer = dreamer;
    self.fullName = dreamer.fullName;
    self.detailsDreamer = [self dreamerDetailsFromDreamer:dreamer];
   
    NSString *genderImageName = dreamer.gender == PMDreamerGenderFemale ? @"gender_woman_icon" : @"gender_man_icon";
    self.genderImage = [UIImage imageNamed:genderImageName];
    
    NSString *defaultPhotoName = dreamer.gender == PMDreamerGenderFemale ? @"photo_woman" : @"photo_man";
    self.defaultPhoto = [UIImage imageNamed:defaultPhotoName];

    self.dreambookUrl = [NSURL URLWithString:dreamer.url relativeToURL:self.baseUrl];
    
    self.status = (dreamer.status) ? dreamer.status : @"";
    self.statusDreamer = [dreamer.isVip boolValue] ? PMDreamerStatusVIP : PMDreamerStatusDefault;
    self.isOnline = [dreamer.isOnline boolValue];
    self.photosCount =  dreamer.photosCount;
    self.dreamsCount = dreamer.dreamsCount;
    self.friendsCount = dreamer.friendsCount;
    self.completedCount = dreamer.fullfiledDreamsCount;
    self.marksCount = dreamer.launchesCount;
    self.subscribersCount = dreamer.followersCount;
    self.subscriptionsCount = dreamer.followeesCount;
    
    if ([dreamer.isFriend boolValue]) {
        self.subscriptionType = PMDreamerSubscriptionTypeFriend;
    }
    else if ([dreamer.isFollower boolValue]) {
        self.subscriptionType = PMDreamerSubscriptionTypeSubscriber;
    }
    else {
        self.subscriptionType = PMDreamerSubscriptionTypeNope;
    };
    
    if ([dreamer.isBlocked boolValue]) {
        self.notAvailableImage = [UIImage imageNamed:@"dreamer_blocked"];
        self.dreamerStateMessage = NSLocalizedString(@"dreambook.dreambook.dreamer_blocked", nil);
        self.accessState = PMDreamerAccessStateBlocked;
    }
    else if ([dreamer.isDeleted boolValue]) {
        self.notAvailableImage = [UIImage imageNamed:@"dreamer_bye"];
        self.dreamerStateMessage = NSLocalizedString(@"dreambook.dreambook.dreamer_deleted", nil);
        self.accessState = PMDreamerAccessStateDeleted;
    }
    else {
        self.accessState = PMDreamerAccessStateAvailable;
    }
}

- (void)setPostsCountInteger:(NSUInteger)postsCountInteger
{
    self->_postsCountInteger = postsCountInteger;
    NSString *description = (self.isMe) ? NSLocalizedString(@"dreambook.header.my_notes", nil) : NSLocalizedString(@"dreambook.header.all_notes", nil);
    self.postsCount = [NSString stringWithFormat:@"%@ %lu", description, (unsigned long)postsCountInteger];
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
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                      fromDate:birthday
                                                                        toDate:now
                                                                       options:0];
    
    NSInteger age = [ageComponents year];
    
    return [NSString stringWithFormat:@"%lu", (long)age];
}


@end