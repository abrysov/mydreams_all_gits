//
//  UserListViewController.h
//  MyDreams
//
//  Created by Игорь on 18.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "UserFilter.h"
#import "UserFilterViewController.h"

@interface UserListViewController : BaseViewController<UserFilterApplyDelegate>

@property (strong, nonatomic) UserFilter *filter;

@end
