//
//  PMFriendshipRequest.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@class PMDreamer;

@interface PMFriendshipRequest : PMBaseModel
@property (strong, nonatomic, readonly) PMDreamer *sender;
@property (strong, nonatomic, readonly) PMDreamer *receiver;
@end
