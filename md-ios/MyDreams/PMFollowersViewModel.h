//
//  PMFollowersViewModel.h
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMFollowersViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *dreamers;
@property (assign, nonatomic, readonly) NSUInteger totalCount;
@end