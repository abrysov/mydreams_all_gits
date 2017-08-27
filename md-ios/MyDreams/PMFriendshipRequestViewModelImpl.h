//
//  PMFriendshipRequestViewModelImpl.h
//  MyDreams
//
//  Created by user on 01.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestViewModel.h"
#import "PMDreamer.h"

@interface PMFriendshipRequestViewModelImpl : NSObject <PMFriendshipRequestViewModel>
@property (strong, nonatomic) RACSignal *avatarSignal;
- (instancetype)initWithDreamer:(PMDreamer *)dreamer;
@end
