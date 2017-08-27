//
//  PMDreamClubHeaderViewModelImpl.m
//  MyDreams
//
//  Created by user on 08.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubHeaderViewModelImpl.h"
#import "PMDreamer.h"

@interface PMDreamClubHeaderViewModelImpl ()
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *status;
@property (assign, nonatomic) NSUInteger photosCount;
@property (assign, nonatomic) NSUInteger dreamsCount;
@property (assign, nonatomic) NSUInteger completedCount;
@property (assign, nonatomic) NSUInteger marksCount;
@property (assign, nonatomic) NSUInteger friendsCount;
@property (assign, nonatomic) NSUInteger subscribersCount;
@property (assign, nonatomic) NSUInteger subscriptionsCount;
@end

@implementation PMDreamClubHeaderViewModelImpl

- (instancetype)initWithDreamer:(PMDreamer *)dreamer
{
    self = [super init];
    if (self) {
        self.fullName = dreamer.fullName;
        self.status = dreamer.status;
        self.photosCount =  dreamer.photosCount;
        self.dreamsCount = dreamer.dreamsCount;
        self.friendsCount = dreamer.friendsCount;
        self.completedCount = dreamer.fullfiledDreamsCount;
        self.marksCount = dreamer.launchesCount;
        self.subscribersCount = dreamer.followersCount;
        self.subscriptionsCount = dreamer.followeesCount;
    }
    return self;
}

@end
