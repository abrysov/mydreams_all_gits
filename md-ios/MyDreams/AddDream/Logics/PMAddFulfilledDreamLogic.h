//
//  PMAddDreamLogic.h
//  myDreams
//
//  Created by AlbertA on 16/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMAddSuccessfulDreamViewModel;

extern NSString * const PMAddDreamLogicErrorDomain;

@interface PMAddFulfilledDreamLogic : PMBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *sendDreamCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *titleDreamTerminal;
@property (nonatomic, strong, readonly) id<PMAddSuccessfulDreamViewModel> viewModel;
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *descriptionDream;
@end
