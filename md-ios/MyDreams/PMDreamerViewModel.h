//
//  PMDreamerViewModel.h
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerSubscriptionType.h"

@protocol PMDreamerViewModel <NSObject>
@property (strong, nonatomic, readonly) NSNumber *dreamerIdx;
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *dreamerDetails;
@property (strong, nonatomic, readonly) UIImage *genderImage;

@property (assign, nonatomic, readonly) BOOL isVip;

@property (assign, nonatomic, readonly) BOOL isOnline;
@property (assign, nonatomic, readonly) PMDreamerSubscriptionType subscriptionType;
@property (strong, nonatomic, readonly) RACSignal *avatarSignal;
@property (strong, nonatomic, readonly) RACSignal *friendshipRequestSignal;
@property (strong, nonatomic, readonly) RACSignal *destroyFriendshipRequestSignal;
@end
