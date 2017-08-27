//
//  PMDreamerViewModelImpl.h
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamerViewModel.h"

@class PMDreamer;

@interface PMDreamerViewModelImpl : NSObject <PMDreamerViewModel>

@property (strong, nonatomic) RACSignal *avatarSignal;
@property (strong, nonatomic) RACSignal *friendshipRequestSignal;
@property (strong, nonatomic) RACSignal *destroyFriendshipRequestSignal;
@property (assign, nonatomic) PMDreamerSubscriptionType subscriptionType;

- (instancetype)initWithDreamer:(PMDreamer *)dreamer;
@end
