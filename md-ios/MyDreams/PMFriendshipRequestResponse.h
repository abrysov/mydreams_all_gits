//
//  PMFriendshipRequestResponse.h
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"
#import "PMFriendshipRequest.h"

@interface PMFriendshipRequestResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) PMFriendshipRequest *friendshipRequest;
@end
