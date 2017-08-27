//
//  PMRemaindPasswordLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 03.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

extern NSString * const PMRemaindPasswordLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMRemaindPasswordLogicError) {
    PMRemaindPasswordLogicErrorInvalidInput = 3,
};

@protocol PMAuthService;

@interface PMRemaindPasswordLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (nonatomic, strong, readonly) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong, readonly) RACCommand *sendEmailCommand;
@property (nonatomic, strong, readonly) RACCommand *backCommand;

@property (assign, nonatomic, readonly) BOOL isValidInput;
@property (assign, nonatomic, readonly) BOOL isValidEmail;
@end
