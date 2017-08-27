//
//  PMFollowerViewModelImpl.h
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookDreamerViewModel.h"
#import "PMDreamer.h"

@interface PMDreambookDreamerViewModelImpl : NSObject <PMDreambookDreamerViewModel>
@property (strong, nonatomic) RACSignal *avatarSignal;
- (instancetype)initWithDreamer:(PMDreamer *)dreamer;
@end
