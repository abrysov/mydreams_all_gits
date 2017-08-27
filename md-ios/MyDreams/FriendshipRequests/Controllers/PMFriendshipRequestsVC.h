//
//  PMFriendshipRequestsVC.h
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"
#import "PMFriendshipRequestsLogic.h"

@class PMFriendshipRequestsVC;

@protocol PMFriendshipRequestsDelegate <NSObject>
-(void)friendshipRequestsVC:(PMFriendshipRequestsVC *)friendshipRequestsVC requestsLoaded:(BOOL)requestsLoaded;
- (void)updateData;
@end

@interface PMFriendshipRequestsVC : PMBaseVC
@property (strong, nonatomic) PMFriendshipRequestsLogic *logic;
@property (weak, nonatomic) id <PMFriendshipRequestsDelegate> delegate;
@end
