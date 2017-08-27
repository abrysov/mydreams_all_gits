//
//  PMFriendshipRequestsResponse.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMFriendshipRequest;

@interface PMFriendshipRequestsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMFriendshipRequest *> *friendshipRequests;
@end
