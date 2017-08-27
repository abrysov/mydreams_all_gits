//
//  PMDreamClubPMDreamClubLogic.h
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamclubWrapperApiClient;
@protocol PMPostMapper;
@protocol PMDreamClubViewModel;
@class PMDreamClubHeaderLogic;

extern NSString * const PMDreamClubLogicErrorDomain;

@interface PMDreamClubLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamclubWrapperApiClient> dreamclubWrapperApiClient;
@property (strong, nonatomic) id<PMPostMapper> postMapper;
@property (strong, nonatomic, readonly) id<PMDreamClubViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *toFullPostCommand;
@property (weak, nonatomic) PMBaseLogic *containerLogic;
@end
