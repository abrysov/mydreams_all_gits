//
//  PMPostMapperImpl.m
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostMapperImpl.h"
#import "PMPost.h"
#import "PMPostViewModelImpl.h"
#import "PMImageDownloader.h"
#import "PMPostPhoto.h"
#import "PMLikeApiClient.h"
#import "PMPaginationBaseLogic+Protected.h"

@implementation PMPostMapperImpl

- (NSArray *)postsToViewModels:(NSArray *)posts paginationLogic:(PMPaginationBaseLogic *)logic
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:posts.count];
    
    for (PMPost *post in posts) {
        PMPostViewModelImpl *viewModel = [[PMPostViewModelImpl alloc] initWithPost:post];
        
        NSURL *imageUrl = [NSURL URLWithString:post.photos.firstObject.photo.large];
        if (imageUrl) {
            viewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
        }
        
        NSURL *avatarUrl = [NSURL URLWithString:post.dreamer.avatar.medium];
        if (avatarUrl) {
            viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
        }
        
        viewModel.likedSignal = [[self.likeApiClient createLikeWithIdx:post.idx entityType:PMEntityTypePost] doNext:^(id x) {
            post.likedByMe = YES;
            post.likesCount = post.likesCount + 1;
            [logic updateItem:post];
        }];
        
        viewModel.removeLikeSignal = [[self.likeApiClient removeLikeWithIdx:post.idx entityType:PMEntityTypePost] doNext:^(id x) {
            post.likedByMe = NO;
            post.likesCount = post.likesCount - 1;
            [logic updateItem:post];
        }];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

@end
