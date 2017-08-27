//
//  PMBlockedProfileLogic.h
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

@interface PMBlockedProfileLogic : PMBaseLogic
@property (nonatomic, strong) NSString *supportEmail;

@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *openEmailCommand;
@end
