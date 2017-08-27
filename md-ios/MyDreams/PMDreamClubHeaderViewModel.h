//
//  PMDreamClubHeaderViewModel.h
//  MyDreams
//
//  Created by user on 08.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMDreamClubHeaderViewModel <NSObject>
@property (strong, nonatomic, readonly) NSString *fullName;
@property (strong, nonatomic, readonly) NSString *status;
@property (strong, nonatomic, readonly) UIImage *avatar;
@property (strong, nonatomic, readonly) UIImage *background;
@property (assign, nonatomic, readonly) NSUInteger photosCount;
@property (assign, nonatomic, readonly) NSUInteger dreamsCount;
@property (assign, nonatomic, readonly) NSUInteger completedCount;
@property (assign, nonatomic, readonly) NSUInteger marksCount;
@property (assign, nonatomic, readonly) NSUInteger friendsCount;
@property (assign, nonatomic, readonly) NSUInteger subscribersCount;
@property (assign, nonatomic, readonly) NSUInteger subscriptionsCount;
@end