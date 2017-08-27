//
//  PMNewsFeedViewModelImpl.h
//  MyDreams
//
//  Created by user on 04.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsFeedViewModel.h"

@interface PMNewsFeedViewModelImpl : NSObject <PMNewsFeedViewModel>
@property (strong, nonatomic) NSArray *items;
@property (assign, nonatomic) NSUInteger postsCountInteger;
@end
