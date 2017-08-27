//
//  PMCreatePostViewModel.h
//  MyDreams
//
//  Created by user on 28.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMCreatePostViewModel <NSObject>
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, assign, readonly) CGFloat progress;
@end
