//
//  PMNewsFeedViewModel.h
//  MyDreams
//
//  Created by user on 04.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMNewsFeedViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *items;
@property (strong, nonatomic, readonly) NSString *postsCount;
@end
