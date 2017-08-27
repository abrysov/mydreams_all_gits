//
//  PMUserAgreementLogic.h
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMAuthService.h"
#import "PMUserAgreementViewModelImpl.h"

extern NSString * const PMUserAgreementLogicErrorDomain;

@interface PMUserAgreementLogic : PMBaseLogic
@property (strong, nonatomic) id<PMAuthService> authService;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) id<PMUserAgreementViewModel> viewModel;
@end
