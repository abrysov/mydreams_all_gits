//
//  PMDetailedLikesLogic.h
//  MyDreams
//
//  Created by Alexey Yakunin on 22/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMDetailedLikesViewModel.h"

@protocol PMLikeApiClient;
@protocol PMImageDownloader;

@interface PMDetailedLikesLogic : PMPaginationBaseLogic
@property (nonatomic, strong, readonly) id<PMDetailedLikesViewModel> viewModel;
@property (nonatomic, strong) id<PMLikeApiClient> likeApiClient;
@property (nonatomic, strong) id<PMImageDownloader> imageDownloader;
@end
