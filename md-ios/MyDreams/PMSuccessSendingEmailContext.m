//
//  PMSuccessSendingEmailContext.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSuccessSendingEmailContext.h"

@implementation PMSuccessSendingEmailContext

+ (PMSuccessSendingEmailContext *)contextWithEmail:(NSString *)email
{
    PMSuccessSendingEmailContext *context = [self new];
    context.email = email;
    
    return context;
}

@end
