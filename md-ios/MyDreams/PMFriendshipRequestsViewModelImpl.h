//
//  PMFriendshipRequestsViewModelImpl.h
//  MyDreams
//
//  Created by user on 01.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestsViewModel.h"

@interface PMFriendshipRequestsViewModelImpl : NSObject <PMFriendshipRequestsViewModel>
@property (strong, nonatomic) NSArray *dreamers;
@property (assign, nonatomic) NSUInteger totalCount;
@property (assign, nonatomic) NSUInteger requestCount;
@property (assign, nonatomic) BOOL isMe;
@end