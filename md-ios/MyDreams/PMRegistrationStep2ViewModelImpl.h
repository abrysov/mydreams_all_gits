//
//  PMRegistrationStep2ViewModelImpl.h
//  MyDreams
//
//  Created by user on 01.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep2ViewModel.h"

@class PMUserForm;

@interface PMRegistrationStep2ViewModelImpl : NSObject <PMRegistrationStep2ViewModel>
- (instancetype)initWithUserForm:(PMUserForm *)userForm;
@end
