//
//  PMPostViewModelImpl.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostViewModel.h"

@class PMPost;

@interface PMPostViewModelImpl : NSObject <PMPostViewModel>
@property (strong, nonatomic) RACSignal *imageSignal;
@property (strong, nonatomic) RACSignal *avatarSignal;
@property (strong, nonatomic) RACSignal *likedSignal;
@property (strong, nonatomic) RACSignal *removeLikeSignal;
- (instancetype)initWithPost:(PMPost *)post;
@end
