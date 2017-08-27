//
//  PMDetailedPostPageLogic.h
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMDetailedPostPageViewModel.h"

@protocol PMPostApiClient;
@protocol PMImageDownloader;
@protocol PMLikeApiClient;
@protocol PMUserProvider;
@protocol PMCommentsApiClient;

extern NSString * const PMDetailedPostLogicErrorDomain;

@interface PMDetailedPostLogic : PMBaseLogic
@property (nonatomic, strong) id<PMPostApiClient> postApiClient;
@property (nonatomic, strong) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic) id<PMLikeApiClient> likeApiClient;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@property (strong, nonatomic) id<PMCommentsApiClient> commentsApiClient;
@property (nonatomic, strong, readonly) id<PMDetailedPostPageViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *likedCommand;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *toEditingPostCommand;
@property (nonatomic, strong, readonly) RACCommand *deletePostCommand;
@property (nonatomic, strong, readonly) RACCommand *likesListCommand;
- (void)setupComment:(NSString *)comment;
@end
