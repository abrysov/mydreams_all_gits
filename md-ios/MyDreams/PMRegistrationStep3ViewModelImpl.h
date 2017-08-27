//
//  PMRegistrationStep3ViewModelImpl.h
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep3ViewModel.h"
#import "PMUserForm.h"

@interface PMRegistrationStep3ViewModelImpl : NSObject <PMRegistrationStep3ViewModel>
- (instancetype)initWithUserForm:(PMUserForm *)userForm errorSubject:(RACSubject *)errorSubject;
@end
