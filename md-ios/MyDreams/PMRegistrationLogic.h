//
//  PMRegistrationLogic.h
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMUserProvider.h"
#import "PMAuthService.h"
#import "PMRegistrationViewModel.h"
#import "PMApplicationRouter.h"

@protocol PMApplicationRouter;
@protocol PMSocketClient;

@class PMEmailValidator;

@interface PMRegistrationLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (nonatomic, strong) PMEmailValidator *emailValidator;
@property (strong, nonatomic) id<PMSocketClient> socketClient;


@property (nonatomic, strong, readonly) id<PMRegistrationViewModel> viewModel;

@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *nextStepCommand;

@property (nonatomic, strong, readonly) RACCommand *loginWithVKCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithFacebookCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithInstagrammCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithTwitterCommand;

@property (nonatomic, strong, readonly) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *passwordTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *confirmPasswordTerminal;
@end
