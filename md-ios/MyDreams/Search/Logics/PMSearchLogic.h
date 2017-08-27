//
//  PMSearchLogic.h
//  myDreams
//
//  Created by AlbertA on 26/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMDreamerApiClient;
@protocol PMPostApiClient;
@protocol PMSearchViewModel;
@protocol PMDreamMapper;
@protocol PMDreamerMapper;
@protocol PMPostMapper;

extern NSString * const PMSearchLogicErrorDomain;

@interface PMSearchLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (strong, nonatomic) id<PMDreamMapper> dreamMapper;
@property (strong, nonatomic) id<PMDreamerMapper> dreamerMapper;
@property (strong, nonatomic) id<PMPostMapper> postMapper;
@property (strong, nonatomic, readonly) id<PMSearchViewModel> viewModel;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@property (strong, nonatomic, readonly) RACCommand *searchItemsCommand;
@property (strong, nonatomic, readonly) RACCommand *toFullDreamCommand;
@property (strong, nonatomic, readonly) RACCommand *toFullPostCommand;
@property (strong, nonatomic, readonly) RACCommand *toDreambookCommand;
@end
