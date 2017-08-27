//
//  PMEditPostViewModelImpl.h
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditPostViewModel.h"

@class PMPostForm;

@interface PMEditPostViewModelImpl : NSObject <PMEditPostViewModel>
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImage *photo;
- (instancetype)initWithPostForm:(PMPostForm *)form;
@end
