//
//  PMFriendsApiClient.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@class PMPage;
@class PMDreamerFilterForm;

@protocol PMFriendsApiClient <NSObject>
- (RACSignal *)createFriendshipRequest:(NSNumber *)idx;
- (RACSignal *)getFriendshipRequests:(BOOL)outgoing form:(PMDreamerFilterForm *)form page:(PMPage *)page;
- (RACSignal *)acceptFriendshipRequest:(NSNumber *)idx;
- (RACSignal *)rejectFriendshipRequest:(NSNumber *)idx;
- (RACSignal *)destroyFriendshipRequest:(NSNumber *)idx;
- (RACSignal *)getFriends:(PMDreamerFilterForm *)form page:(PMPage *)page;
- (RACSignal *)getFriendsOfDreamer:(NSNumber *)index filterForm:(PMDreamerFilterForm *)form page:(PMPage *)page;
- (RACSignal *)destroyProfileFriendRequest:(NSNumber *)idx;
- (RACSignal *)getFollowers:(NSNumber *)idx filterForm:(PMDreamerFilterForm *)form page:(PMPage *)page;
- (RACSignal *)getFollowees:(PMDreamerFilterForm *)form page:(PMPage *)page;
@end