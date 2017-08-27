//
//  PMChangePasswordLogic.h
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMProfileApiClient.h"

extern NSString * const PMChangePasswordLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMChangePasswordLogicError) {
    PMChangePasswordLogicErrorInvalidInput = 3,
};

@interface PMChangePasswordLogic : PMBaseLogic
@property (nonatomic, strong) id<PMProfileApiClient> profileApiClient;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *sendCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *currentPasswordTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *passwordTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *passwordConfirmationTerminal;
@property (nonatomic, assign, readonly) BOOL isValidPasswordConfirmation;
@property (nonatomic, assign, readonly) BOOL isValidPassword;
@property (nonatomic, assign, readonly) BOOL isValidCurrentPassword;
@end
