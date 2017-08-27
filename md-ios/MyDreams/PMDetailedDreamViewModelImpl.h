//
//  PMDetailedDreamViewModelImpl.h
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDetailedDreamViewModel.h"

@class PMDream;

@interface PMDetailedDreamViewModelImpl : NSObject <PMDetailedDreamViewModel>
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *avatar;
@property (assign, nonatomic) NSUInteger likesCount;
@property (assign, nonatomic) NSUInteger commentsCount;
@property (assign, nonatomic) BOOL likedByMe;

- (instancetype)initWithDream:(PMDream *)dream isMine:(BOOL)isMine;
@end
