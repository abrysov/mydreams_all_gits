//
//  PMListDreamsLogic.h
//  myDreams
//
//  Created by AlbertA on 25/04/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMDreamsViewModel;
@protocol PMDreamMapper;

extern NSString * const PMListDreamsLogicErrorDomain;

@interface PMListDreamsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMDreamMapper> dreamMapper;
@property (strong, nonatomic, readonly) id<PMDreamsViewModel> dreamsViewModel;

@property (strong, nonatomic, readonly) RACCommand *likedDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *hotDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *freshDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *toFullDreamCommand;

@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@end
