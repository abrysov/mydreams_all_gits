//
//  PMFriendshipRequestsLogic.m
//  myDreams
//
//  Created by AlbertA on 30/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestsLogic.h"
#import "PMFriendsApiClient.h"
#import "PMImageDownloader.h"
#import "PMDreamerFilterForm.h"
#import "PMFriendshipRequestsResponse.h"
#import "PMFriendshipRequestsViewModelImpl.h"
#import "PMFriendshipRequestViewModelImpl.h"
#import "PMPaginationResponseMeta.h"
#import "PMFriendshipRequest.h"
#import "PMBaseLogic+Protected.h"

NSString * const PMFriendshipRequestsLogicErrorDomain = @"com.mydreams.FriendshipRequests.logic.error";

@interface PMFriendshipRequestsLogic ()
@property (nonatomic, strong) PMDreamerFilterForm *filterForm;
@property (nonatomic, strong) PMFriendshipRequestsViewModelImpl *viewModel;
@property (strong, nonatomic) RACCommand *addInFriendsCommand;
@property (strong, nonatomic) RACCommand *rejectFriendshipRequestCommand;
@end

@implementation PMFriendshipRequestsLogic

- (void)startLogic
{
    self.ignoreDataEmpty = YES;
    self.filterForm = [[PMDreamerFilterForm alloc] init];
    self.viewModel = [[PMFriendshipRequestsViewModelImpl alloc] init];
    [super startLogic];

    @weakify(self);
    RAC(self, viewModel.dreamers) = [RACObserve(self, items)
        map:^id(NSArray *items) {
            @strongify(self);
            return [self friendshipRequestsToViewModels:items];
        }];
    
    self.addInFriendsCommand = [self createAddInFriendsCommand];
    self.rejectFriendshipRequestCommand = [self createRejectFriendshipRequestCommand];
}

- (RACSignal *)loadPage:(PMPage *)page
{
    if (self.isMe) {
        @weakify(self);
        return [[[self.friendsApiClient getFriendshipRequests:NO form:self.filterForm page:page]
            doNext:^(PMFriendshipRequestsResponse *response) {
                @strongify(self)
                PMFriendshipRequestsViewModelImpl *viewModel = self.viewModel;
                viewModel.requestCount = response.meta.totalCount;
            }]
            map:^RACTuple *(PMFriendshipRequestsResponse *response) {
                return RACTuplePack(response.friendshipRequests, response.meta);
            }];
    }
    return [RACSignal empty];
} 

- (RACCommand *)createLoadDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[self loadData]
            doError:^(NSError *error) {
                @strongify(self);
                self.isDataLoaded = NO;
            }]
            doCompleted:^{
                @strongify(self);
                self.isDataLoaded = YES;
            }];
    }];
}

#pragma mark - commands

- (RACCommand *)createAddInFriendsCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *idx) {
        @strongify(self);
        return [[self.friendsApiClient acceptFriendshipRequest:idx] doNext:^(id input) {
            @strongify(self);
            [self.loadDataCommand execute:input];
        }];
    }];
}

- (RACCommand *)createRejectFriendshipRequestCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *idx) {
        @strongify(self);
        return [[self.friendsApiClient rejectFriendshipRequest:idx] doNext:^(id input) {
            @strongify(self);
            [self.loadDataCommand execute:input];
        }];
    }];
}

#pragma mark - private

- (NSArray *)friendshipRequestsToViewModels:(NSArray *)friendshipRequests
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:friendshipRequests.count];
    
    for (PMFriendshipRequest *friendshipRequest in friendshipRequests) {
        PMFriendshipRequestViewModelImpl *viewModel = [[PMFriendshipRequestViewModelImpl alloc] initWithDreamer:friendshipRequest.sender];
        NSURL *avatarUrl = [NSURL URLWithString:friendshipRequest.sender.avatar.medium];
        viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
        [viewModels addObject:viewModel];
    }
    return [NSArray arrayWithArray:viewModels];
}
@end
