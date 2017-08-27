//
//  PMUserContext.m
//  MyDreams
//
//  Created by user on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserContext.h"

@implementation PMUserContext

+ (PMUserContext *)contextWithUserForm:(PMUserForm *)userForm
{
    PMUserContext *context = [self new];
    context.userForm = userForm;
    context.errorsSubject = [RACSubject subject];
    return context;
}

@end
