//
//  PMFriendsResponse.h
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMDreamer;

@interface PMFriendsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMDreamer *> *friends;
@end
