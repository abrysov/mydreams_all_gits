//
//  PMMyDreambookViewModel.h
//  MyDreams
//
//  Created by user on 09.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerStatus.h"
#import "PMDreamerGender.h"
#import "PMDreamerSubscriptionType.h"
#import "PMDreamerAccessState.h"

@protocol PMDreambookHeaderViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *detailsDreamer;
@property (strong, nonatomic, readonly) NSString *status;
@property (assign, nonatomic, readonly) NSUInteger photosCount;
@property (assign, nonatomic, readonly) NSUInteger dreamsCount;
@property (assign, nonatomic, readonly) NSUInteger completedCount;
@property (assign, nonatomic, readonly) NSUInteger marksCount;
@property (assign, nonatomic, readonly) NSUInteger friendsCount;
@property (assign, nonatomic, readonly) NSUInteger subscribersCount;
@property (assign, nonatomic, readonly) NSUInteger subscriptionsCount;
@property (assign, nonatomic, readonly) NSInteger marksBadgeValue;
@property (strong, nonatomic, readonly) NSURL *dreambookUrl;
@property (assign, nonatomic, readonly) PMDreamerStatus statusDreamer;
@property (strong, nonatomic, readonly) UIImage *genderImage;
@property (strong, nonatomic, readonly) UIImage *defaultPhoto;
@property (assign, nonatomic, readonly) BOOL isMe;
@property (assign, nonatomic, readonly) BOOL isOnline;
@property (strong, nonatomic, readonly) UIImage *avatar;
@property (strong, nonatomic, readonly) UIImage *background;
@property (assign, nonatomic, readonly) PMDreamerSubscriptionType subscriptionType;
@property (strong, nonatomic, readonly) UIImage *notAvailableImage;
@property (strong, nonatomic, readonly) NSString *dreamerStateMessage;
@property (assign, nonatomic, readonly) PMDreamerAccessState accessState;
@property (strong, nonatomic, readonly) NSString *postsCount;
@end