//
//  PMEditPostViewModel.h
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMEditPostViewModel <NSObject>
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, assign, readonly) CGFloat progress;
@property (nonatomic, strong, readonly) NSString *postDescription;
@end
