//
//  PMRestoreProfileLogic.h
//  MyDreams
//
//  Created by user on 14.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

extern NSString * const PMRestoreProfileLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMRestoreProfileLogicError) {
    PMRestoreProfileLogicErrorInvalidInput = 3,
};

@protocol PMAuthService;

@interface PMRestoreProfileLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (nonatomic, strong, readonly) RACCommand *sendEmailCommand;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@end
