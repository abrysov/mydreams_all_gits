//
//  PMMenuViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMMenuViewModel.h"

@class PMDreamer;
@class PMStatus;

@interface PMMenuViewModelImpl : NSObject <PMMenuViewModel>
@property (strong, nonatomic) UIImage *avatar;
@property (strong, nonatomic) PMDreamer *me;
@property (strong, nonatomic) PMStatus *status;
@end
