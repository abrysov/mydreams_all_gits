//
//  PMSuccessSendingEmailContext.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@interface PMSuccessSendingEmailContext : PMBaseContext
@property (strong, nonatomic) NSString *email;

+ (PMSuccessSendingEmailContext *)contextWithEmail:(NSString *)email;

@end
