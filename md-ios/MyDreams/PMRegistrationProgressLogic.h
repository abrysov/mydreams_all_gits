//
//  PMRegistrationProgressLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@protocol PMAuthService;
@protocol PMRegistrationProgressViewModel;
@protocol PMApplicationRouter;
@protocol PMProfileApiClient;
@protocol PMSocketClient;

@interface PMRegistrationProgressLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (strong, nonatomic) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (strong, nonatomic) id<PMSocketClient> socketClient;

@property (nonatomic, strong, readonly) id<PMRegistrationProgressViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *registrationCommand;
@end
