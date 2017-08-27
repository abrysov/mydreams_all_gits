//
//  PMListDreamersLogic.h
//  myDreams
//
//  Created by AlbertA on 04/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMDreamersViewModel.h"

@protocol PMDreamerApiClient;
@protocol PMDreamerMapper;
@protocol PMDreamersViewModel;

extern NSString * const PMListDreamersLogicErrorDomain;

@interface PMListDreamersLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@property (strong, nonatomic) id<PMDreamerMapper> dreamerMapper;
@property (strong, nonatomic, readonly) id<PMDreamersViewModel> dreamersViewModel;
@property (strong, nonatomic, readonly) RACCommand *showFiltersDreamersCommand;
@property (strong, nonatomic, readonly) RACCommand *removeFiltersCommand;
@property (strong, nonatomic, readonly) RACCommand *toDreambookCommand;
@property (strong, nonatomic, readonly) RACChannelTerminal *searchTerminal;

@end
