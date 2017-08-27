//
//  PMFriendshipRequestsLogic.h
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMFriendshipRequestsViewModel.h"

@protocol PMFriendsApiClient;
@protocol PMImageDownloader;

extern NSString * const PMFriendshipRequestsLogicErrorDomain;

@interface PMFriendshipRequestsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMFriendsApiClient> friendsApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic, readonly) id<PMFriendshipRequestsViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *addInFriendsCommand;
@property (strong, nonatomic, readonly) RACCommand *rejectFriendshipRequestCommand;
@property (assign, nonatomic) BOOL isMe;
@end
