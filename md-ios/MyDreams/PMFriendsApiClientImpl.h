//
//  PMFriendsApiClientImpl.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendsApiClient.h"

@protocol PMAPIClient;

@interface PMFriendsApiClientImpl : NSObject <PMFriendsApiClient>
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end
