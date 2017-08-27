//
//  PMDreamer.h
//  MyDreams
//
//  Created by Иван Ушаков on 24.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMLocation.h"
#import "PMImage.h"
#import "PMCroppedImage.h"
#import "PMDreamerGender.h"
#import "PMDreamerSubscriptionType.h"

@interface PMDreamer : PMBaseModel
@property (strong, nonatomic, readonly) NSString *fullName;
@property (assign, nonatomic, readonly) PMDreamerGender gender;
@property (strong, nonatomic, readonly) NSNumber *isVip;
@property (strong, nonatomic, readonly) NSNumber *isCelebrity;
@property (strong, nonatomic, readonly) PMLocation *city;
@property (strong, nonatomic, readonly) PMLocation *country;
@property (strong, nonatomic, readonly) NSNumber *visitsCount;
@property (strong, nonatomic, readonly) NSString *firstName;
@property (strong, nonatomic, readonly) NSString *lastName;
@property (strong, nonatomic, readonly) NSDate *birthday;
@property (strong, nonatomic, readonly) NSString *status;
@property (assign, nonatomic, readonly) NSUInteger viewsCount;
@property (assign, nonatomic, readonly) NSUInteger friendsCount;
@property (assign, nonatomic, readonly) NSUInteger dreamsCount;
@property (assign, nonatomic, readonly) NSUInteger fullfiledDreamsCount;
@property (assign, nonatomic, readonly) NSUInteger followeesCount;
@property (assign, nonatomic, readonly) NSUInteger followersCount;
@property (assign, nonatomic, readonly) NSUInteger launchesCount;
@property (assign, nonatomic, readonly) NSUInteger photosCount;
@property (strong, nonatomic, readonly) NSNumber *isBlocked;
@property (strong, nonatomic, readonly) NSNumber *isDeleted;
@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) NSString *url;
@property (strong, nonatomic, readonly) NSNumber *isOnline;
@property (strong, nonatomic, readonly) NSString *token;
@property (strong, nonatomic, readonly) PMImage *avatar;
@property (strong, nonatomic, readonly) PMCroppedImage *dreambookBackground;
@property (strong, nonatomic) NSNumber *isFriend;
@property (strong, nonatomic) NSNumber *isFollower;
@end
