//
//  PMListFriendsLogic.h
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMFriendsViewModel.h"
#import "PMFriendshipRequestsLogic.h"

@protocol PMFriendsApiClient;
@protocol PMDreamerMapper;

extern NSString * const PMListFriendsLogicErrorDomain;

@interface PMListFriendsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMFriendsApiClient> friendsApiClient;
@property (strong, nonatomic) id<PMDreamerMapper> dreamerMapper;
@property (strong, nonatomic, readonly) id<PMFriendsViewModel> friendsViewModel;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic, readonly) RACCommand *backCommand;
@property (strong, nonatomic, readonly) RACCommand *toDreambookCommand;
@property (strong, nonatomic, readonly) RACCommand *updateDateCommand;
@property (weak, nonatomic) PMFriendshipRequestsLogic *containerLogic;
@end
