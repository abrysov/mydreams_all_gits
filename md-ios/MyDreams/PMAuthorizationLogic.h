//
//  PMAuthorizationLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

extern NSString * const PMAuthorizationLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMAuthorizationLogicError) {
    PMAuthorizationLogicErrorInvalidInput = 3,
};

@protocol PMAuthService;
@protocol PMApplicationRouter;
@protocol PMSocketClient;

@interface PMAuthorizationLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (strong, nonatomic) id<PMSocketClient> socketClient;

@property (nonatomic, strong, readonly) RACChannelTerminal *usernameTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *passwordTerminal;

@property (nonatomic, strong, readonly) RACCommand *loginCommand;
@property (nonatomic, strong, readonly) RACCommand *remaindPasswordCommand;
@property (nonatomic, strong, readonly) RACCommand *registrationCommand;

@property (nonatomic, strong, readonly) RACCommand *loginWithVKCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithFacebookCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithInstagrammCommand;
@property (nonatomic, strong, readonly) RACCommand *loginWithTwitterCommand;

@property (nonatomic, assign, readonly) BOOL isValidInput;
@property (nonatomic, assign, readonly) BOOL isValidUsername;
@property (nonatomic, assign, readonly) BOOL isValidPassword;
@end
