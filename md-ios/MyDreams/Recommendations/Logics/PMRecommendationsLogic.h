//
//  PMRecommendationsLogic.h
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMPostApiClient;
@protocol PMPostMapper;
@protocol PMRecommendationsViewModel;

extern NSString * const PMRecommendationsLogicErrorDomain;

@interface PMRecommendationsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (strong, nonatomic) id<PMPostMapper> postMapper;
@property (strong, nonatomic, readonly) id<PMRecommendationsViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *toFullPostCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *selectSourceTypeTerminal;
@end
