//
//  PMChangeEmailLogic.h
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMProfileApiClient.h"

@class PMEmailValidator;

extern NSString * const PMChangeEmailLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMChangeEmailLogicError) {
    PMChangeEmailLogicErrorInvalidInput = 3,
};

@interface PMChangeEmailLogic : PMBaseLogic
@property (nonatomic, strong) id <PMProfileApiClient> profileApiClient;
@property (nonatomic, strong) PMEmailValidator *emailValidator;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *sendCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *currentEmailTerminal;
@property (nonatomic, assign, readonly) BOOL isValidEmail;
@end
