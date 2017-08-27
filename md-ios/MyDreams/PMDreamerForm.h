//
//  PMDreamerForm.h
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserForm.h"
#import "PMImage.h"

@class PMDreamer;

@interface PMDreamerForm : PMUserForm
@property (strong, nonatomic) PMImage *avatarURL;
@property (strong, nonatomic) UIImage *avatar;

- (instancetype)initWithDreamer:(PMDreamer *)dreamer;
@end
