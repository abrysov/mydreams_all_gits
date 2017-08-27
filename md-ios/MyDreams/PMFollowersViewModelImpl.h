//
//  PMFollowersViewModelImpl.h
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFollowersViewModel.h"

@interface PMFollowersViewModelImpl : NSObject <PMFollowersViewModel>
@property (strong, nonatomic) NSArray *dreamers;
@property (assign, nonatomic) NSUInteger totalCount;
@end
