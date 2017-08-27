//
//  PMDreamerMapperImpl.m
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerMapperImpl.h"
#import "PMDreamer.h"
#import "PMDreamerViewModelImpl.h"
#import "PMImageDownloader.h"
#import "PMFriendsApiClient.h"
#import "PMFriendshipRequestResponse.h"
#import "PMPaginationBaseLogic+Protected.h"
#import "PMDreambookDreamerViewModelImpl.h"

@implementation PMDreamerMapperImpl

- (NSArray *)dreamersToViewModels:(NSArray *)dreamers paginationLogic:(PMPaginationBaseLogic *)logic
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:dreamers.count];
    
    for (PMDreamer *dreamer in dreamers) {
        PMDreamerViewModelImpl *viewModel = [[PMDreamerViewModelImpl alloc] initWithDreamer:dreamer];
        
        NSURL *avatarUrl = [NSURL URLWithString:dreamer.avatar.medium];
        viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
        
        viewModel.friendshipRequestSignal = [[self.friendsApiClient createFriendshipRequest:dreamer.idx] doNext:^(PMFriendshipRequestResponse *response) {
            dreamer.isFollower = response.friendshipRequest.receiver.isFollower;
            dreamer.isFriend = response.friendshipRequest.receiver.isFriend;
            [logic updateItem:dreamer];
        }];
        viewModel.destroyFriendshipRequestSignal = [[self.friendsApiClient destroyFriendshipRequest:dreamer.idx] doNext:^(PMFriendshipRequestResponse *response) {
            dreamer.isFriend = @NO;
            dreamer.isFollower = @NO;
            [logic updateItem:dreamer];
        }];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

- (NSArray *)dreambookDreamersToViewModel:(NSArray *)dreamers
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:dreamers.count];
    
    for (PMDreamer *dreamer in dreamers) {
        PMDreambookDreamerViewModelImpl *viewModel = [[PMDreambookDreamerViewModelImpl alloc] initWithDreamer:dreamer];
        
        NSURL *avatarUrl = [NSURL URLWithString:dreamer.avatar.medium];
        viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
        [viewModels addObject:viewModel];
    }
    return [NSArray arrayWithArray:viewModels];
}
@end
