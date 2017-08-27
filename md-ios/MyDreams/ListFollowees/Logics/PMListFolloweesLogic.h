//
//  PMListFolloweesLogic.h
//  myDreams
//
//  Created by AlbertA on 29/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMFollowersViewModel.h"

@protocol PMFriendsApiClient;
@protocol PMDreamerMapper;

extern NSString * const PMListFolloweesLogicErrorDomain;

@interface PMListFolloweesLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMFriendsApiClient> friendsApiClient;
@property (strong, nonatomic) id<PMDreamerMapper> dreamerMapper;
@property (strong, nonatomic, readonly) id<PMFollowersViewModel> followeesViewModel;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic, readonly) RACCommand *backCommand;
@property (strong, nonatomic, readonly) RACCommand *toDreambookCommand;
@end
