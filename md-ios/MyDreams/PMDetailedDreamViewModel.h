//
//  PMDetailedDreamViewModel.h
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMDetailedDreamViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *dreamTitle;
@property (strong, nonatomic, readonly) NSString *dreamerTopInfo;
@property (strong, nonatomic, readonly) NSString *dreamerBottomInfo;
@property (strong, nonatomic, readonly) NSString *date;
@property (strong, nonatomic, readonly) NSString *details;
@property (assign, nonatomic, readonly) NSUInteger likesCount;
@property (assign, nonatomic, readonly) NSUInteger commentsCount;
@property (strong, nonatomic, readonly) NSString *descriptionCommentCount;
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, strong, readonly) UIImage *avatar;
@property (nonatomic, strong, readonly) UIImage *likesViewIcon;
@property (strong, nonatomic, readonly) NSString *age;
@property (assign, nonatomic, readonly) BOOL isMine;
@end