//
//  PMSuccessRemaindPasswordLogic.h
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

@interface PMSuccessSendingEmailLogic : PMBaseLogic
@property (strong, nonatomic, readonly) NSString *email;
@property (strong, nonatomic, readonly) RACCommand *doneCommand;
@property (strong, nonatomic, readonly) RACCommand *resendCommand;
@end
