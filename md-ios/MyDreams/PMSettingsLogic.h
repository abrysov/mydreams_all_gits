//
//  PMSettingsLogic.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@protocol PMAuthService;
@protocol PMProfileApiClient;

@interface PMSettingsLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (strong, nonatomic) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic, readonly) RACCommand *signOutCommand;
@property (strong, nonatomic, readonly) RACCommand *toChangePasswordCommand;
@property (strong, nonatomic, readonly) RACCommand *toChangeEmailCommand;
@property (strong, nonatomic, readonly) RACCommand *toEditProfileCommand;
@property (strong, nonatomic, readonly) RACCommand *accountDeletingCommand;
@end
