//
//  PMFriendshipRequestsViewModel.h
//  MyDreams
//
//  Created by user on 01.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMFriendshipRequestsViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *dreamers;
@property (assign, nonatomic, readonly) NSUInteger totalCount;
@property (assign, nonatomic, readonly) NSUInteger requestCount;
@property (assign, nonatomic, readonly) BOOL isMe;
@end