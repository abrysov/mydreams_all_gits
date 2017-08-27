//
//  PMPostViewModel.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//


@protocol PMPostViewModel <NSObject>
@property (strong, nonatomic, readonly) NSNumber *postIdx;
@property (strong, nonatomic, readonly) NSString *fullNameAndAge;
@property (strong, nonatomic, readonly) NSString *dreamerLocation;
@property (strong, nonatomic, readonly) NSString *date;
@property (strong, nonatomic, readonly) NSString *details;
@property (assign, nonatomic, readonly) NSUInteger likeCount;
@property (assign, nonatomic, readonly) NSUInteger commentsCount;
@property (assign, nonatomic, readonly) BOOL likedByMe;
@property (strong, nonatomic, readonly) RACSignal *imageSignal;
@property (strong, nonatomic, readonly) RACSignal *avatarSignal;
@property (strong, nonatomic, readonly) RACSignal *likedSignal;
@property (strong, nonatomic, readonly) RACSignal *removeLikeSignal;
@end
