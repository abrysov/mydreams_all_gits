//
//  PMRegistrationViewModelImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationViewModelImpl.h"
#import "PMUserForm.h"

@interface PMRegistrationViewModelImpl ()
@property (nonatomic, assign) BOOL isValidPassword;
@property (nonatomic, assign) BOOL isValidEmail;
@property (nonatomic, assign) BOOL isValidConfirmPassword;
@end

@implementation PMRegistrationViewModelImpl

- (instancetype)initWithUserForm:(PMUserForm *)userForm
{
    self = [super init];
    if (self) {
        RAC(self, isValidPassword) = RACObserve(userForm, isValidPassword);
        RAC(self, isValidEmail) = RACObserve(userForm, isValidEmail);
        RAC(self, isValidConfirmPassword) = RACObserve(userForm, isValidConfirmPassword);
    }
    
    return self;
}

@end
