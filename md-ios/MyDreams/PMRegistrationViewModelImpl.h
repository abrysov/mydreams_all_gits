//
//  PMRegistrationViewModelImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMRegistrationViewModel.h"

@class PMUserForm;

@interface PMRegistrationViewModelImpl : NSObject <PMRegistrationViewModel>
- (instancetype)initWithUserForm:(PMUserForm *)userForm;
@end
