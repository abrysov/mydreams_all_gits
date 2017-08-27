//
//  PMDreamViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMDreamViewModel <NSObject>
@property (strong, nonatomic, readonly) NSNumber *dreamIdx;
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *dreamerDetails;
@property (strong, nonatomic, readonly) NSString *date;
@property (strong, nonatomic, readonly) NSString *certificateType;

@property (strong, nonatomic, readonly) UIImage *genderImage;

@property (strong, nonatomic, readonly) NSString *titile;
@property (strong, nonatomic, readonly) NSString *details;

@property (assign, nonatomic, readonly) NSUInteger likeCount;
@property (assign, nonatomic, readonly) NSUInteger commentsCount;
@property (assign, nonatomic, readonly) NSUInteger lounchCount;

@property (strong, nonatomic, readonly) RACSignal *imageSignal;
@property (strong, nonatomic, readonly) RACSignal *avatarSignal;
@property (strong, nonatomic, readonly) RACSignal *likedSignal;
@property (strong, nonatomic, readonly) RACSignal *removeLikeSignal;

@property (strong, nonatomic, readonly) UIColor *color;

@property (assign, nonatomic, readonly) BOOL likedByMe;
@property (strong, nonatomic, readonly) NSString *positionString;
@end
