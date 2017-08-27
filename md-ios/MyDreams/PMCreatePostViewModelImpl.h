//
//  PMCreatePostViewModelImpl.h
//  MyDreams
//
//  Created by user on 28.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCreatePostViewModel.h"

@interface PMCreatePostViewModelImpl : NSObject <PMCreatePostViewModel>
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIImage *photo;
@end
