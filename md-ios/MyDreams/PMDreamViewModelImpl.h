//
//  PMDreamViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamViewModel.h"

@class PMDream;
@class PMTopDream;

@interface PMDreamViewModelImpl : NSObject <PMDreamViewModel>
@property (assign, nonatomic) NSUInteger position;
@property (strong, nonatomic) RACSignal *imageSignal;
@property (strong, nonatomic) RACSignal *avatarSignal;
@property (strong, nonatomic) RACSignal *likedSignal;
@property (strong, nonatomic) RACSignal *removeLikeSignal;
- (instancetype)initWithDream:(PMDream *)dream;
- (instancetype)initWithTopDream:(PMTopDream *)dream;
@end
