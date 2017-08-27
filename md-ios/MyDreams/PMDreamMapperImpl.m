//
//  PMDreamMapper.m
//  MyDreams
//
//  Created by user on 28.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamMapperImpl.h"
#import "PMImageDownloader.h"
#import "PMLikeApiClient.h"
#import "PMDreamViewModelImpl.h"
#import "PMDream.h"
#import "PMDreamer.h"
#import "PMPaginationBaseLogic+Protected.h"

@implementation PMDreamMapperImpl

- (NSArray *)dreamsToViewModels:(NSArray *)dreams paginationLogic:(PMPaginationBaseLogic *)logic
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:dreams.count];
    
    for (PMDream *dream in dreams) {
        PMDreamViewModelImpl *viewModel = [[PMDreamViewModelImpl alloc] initWithDream:dream];
        
        NSURL *imageUrl = [NSURL URLWithString:dream.image.large];
        if (imageUrl) {
            viewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
        }
        
        NSURL *avatarUrl = [NSURL URLWithString:dream.dreamer.avatar.medium];
        if (avatarUrl) {
            viewModel.avatarSignal = [self.imageDownloader imageForURL:avatarUrl];
        }
        
        viewModel.likedSignal = [[self.likeApiClient createLikeWithIdx:dream.idx entityType:PMEntityTypeDream] doNext:^(id x) {
            dream.likedByMe = YES;
            dream.likesCount = dream.likesCount + 1;
            [logic updateItem:dream];
        }];
        
        viewModel.removeLikeSignal = [[self.likeApiClient removeLikeWithIdx:dream.idx entityType:PMEntityTypeDream] doNext:^(id x) {
            dream.likedByMe = NO;
            dream.likesCount = dream.likesCount - 1;
            [logic updateItem:dream];
        }];
        
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

@end
