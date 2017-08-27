//
//  PMListCompletedDreamsLogic.h
//  myDreams
//
//  Created by AlbertA on 28/04/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMDreamsViewModel;
@protocol PMDreamMapper;

extern NSString * const PMListCompletedDreamsLogicErrorDomain;

@interface PMListCompletedDreamsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMDreamMapper> dreamMapper;
@property (strong, nonatomic, readonly) id<PMDreamsViewModel> dreamsViewModel;

@property (strong, nonatomic, readonly) RACCommand *allDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *maleDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *femaleDreamsCommand;
@property (strong, nonatomic, readonly) RACCommand *toAddDreamCommand;
@property (strong, nonatomic, readonly) RACCommand *toFullDreamCommand;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;
@end
