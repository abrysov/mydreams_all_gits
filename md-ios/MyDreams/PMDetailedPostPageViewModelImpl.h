//
//  PMDetailedPostPageViewModelImpl.h
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDetailedPostPageViewModel.h"

@class PMPost;

@interface PMDetailedPostPageViewModelImpl : NSObject <PMDetailedPostPageViewModel>
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) UIImage *avatar;
@property (assign, nonatomic) NSUInteger likesCount;
@property (assign, nonatomic) NSUInteger commentsCount;
@property (assign, nonatomic) BOOL likedByMe;

- (instancetype)initWithPost:(PMPost *)post isMine:(BOOL)isMine;
@end
