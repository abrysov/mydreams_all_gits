//
//  PMFriendshipRequestView.h
//  MyDreams
//
//  Created by user on 29.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestViewModel.h"

@interface PMFriendshipRequestView : UIView
@property (strong, nonatomic) id <PMFriendshipRequestViewModel> viewModel;
@property (strong, nonatomic) RACCommand *addInFriendsCommand;
@property (strong, nonatomic) RACCommand *rejectFriendshipRequestCommand;
@end
