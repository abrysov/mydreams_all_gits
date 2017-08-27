//
//  PMUserContext.h
//  MyDreams
//
//  Created by user on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"
#import "PMUserForm.h"

@interface PMUserContext : PMBaseContext
@property (nonatomic, strong) PMUserForm *userForm;
@property (nonatomic, strong) RACSubject *errorsSubject;

+ (PMUserContext *)contextWithUserForm:(PMUserForm *)userForm;
@end
