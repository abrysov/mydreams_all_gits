//
//  PMFriendshipRequestVIewModel.h
//  MyDreams
//
//  Created by user on 01.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMFriendshipRequestViewModel <NSObject>
@property (strong, nonatomic, readonly) NSNumber *dreamerIdx;
@property (strong, nonatomic, readonly) NSString *topInfo;
@property (strong, nonatomic, readonly) NSString *bottomInfo;
@property (assign, nonatomic, readonly) BOOL isVip;
@property (assign, nonatomic, readonly) BOOL isOnline;
@property (strong, nonatomic, readonly) RACSignal *avatarSignal;
@end