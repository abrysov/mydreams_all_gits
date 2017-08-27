//
//  PMListFollowersLogic.h
//  MyDreams
//
//  Created by user on 24.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMFollowersViewModel.h"

@protocol PMFriendsApiClient;
@protocol PMDreamerMapper;

extern NSString * const PMListFollowersLogicErrorDomain;

@interface PMListFollowersLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMFriendsApiClient> friendsApiClient;
@property (strong, nonatomic) id<PMDreamerMapper> dreamerMapper;
@property (strong, nonatomic, readonly) id<PMFollowersViewModel> followersViewModel;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic, readonly) RACCommand *backCommand;
@property (strong, nonatomic, readonly) RACCommand *toDreambookCommand;
@end
