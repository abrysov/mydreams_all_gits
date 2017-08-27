//
//  PMEditProfileViewModelImpl.h
//  MyDreams
//
//  Created by user on 02.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMEditProfileViewModel.h"
#import "PMDreamerForm.h"

@interface PMEditProfileViewModelImpl : NSObject <PMEditProfileViewModel>
@property (strong, nonatomic) UIImage *avatar;
- (instancetype)initWithDreamerForm:(PMDreamerForm *)dreamerForm;
@end
