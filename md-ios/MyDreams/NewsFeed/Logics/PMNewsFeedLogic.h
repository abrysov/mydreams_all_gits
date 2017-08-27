//
//  PMNewsFeedLogic.h
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMPostApiClient;
@protocol PMPostMapper;
@protocol PMNewsFeedViewModel;

extern NSString * const PMNewsFeedLogicErrorDomain;

@interface PMNewsFeedLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (strong, nonatomic) id<PMPostMapper> postMapper;
@property (strong, nonatomic, readonly) id<PMNewsFeedViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *toFullPostCommand;
@property (strong, nonatomic, readonly) RACCommand *createPostCommand;
@end
