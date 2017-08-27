//
//  PMDreamClubHeaderPMDreamClubHeaderLogic.h
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMContainedListPhotosLogicDelegate.h"

@protocol PMDreamclubWrapperApiClient;
@protocol PMDreamClubHeaderViewModel;
@protocol PMImageDownloader;

extern NSString * const PMDreamClubHeaderLogicErrorDomain;

@interface PMDreamClubHeaderLogic : PMBaseLogic
@property (nonatomic, strong) id<PMDreamclubWrapperApiClient> dreamclubWrapperApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic, readonly) id<PMDreamClubHeaderViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *toSectionCommand;
@property (nonatomic, strong, readonly) RACCommand *sendMessageCommand;
@property (weak, nonatomic) PMBaseLogic <PMContainedListPhotosLogicDelegate> *containerLogic;
@end
