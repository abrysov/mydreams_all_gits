//
//  PMDataFetcher.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPollingDataFetcher.h"
#import "PMDreamerApiClient.h"
#import "PMStatusResponse.h"

@interface PMPollingDataFetcher ()
@property (strong, nonatomic) RACScheduler *scheduler;

@property (strong, nonatomic) RACSubject *statusSubject;
@property (strong, nonatomic) RACDisposable *statusDisposable;
@end

@implementation PMPollingDataFetcher

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:NSStringFromClass(self.class)];
        self.statusSubject = [RACSubject subject];
    }
    
    return self;
}

- (void)start
{
    @weakify(self);
    if (!self.statusDisposable) {
        self.statusDisposable = [self.scheduler after:[NSDate date] repeatingEvery:60.0f withLeeway:5.0f schedule:^{
            @strongify(self);
            [[self.dreamerApiClient getStatus] subscribeNext:^(PMStatusResponse *response) {
                @strongify(self);
                [self.statusSubject sendNext:response.status];
            }];
        }];
    }
}

- (void)stop
{
    if (self.statusDisposable) {
        [self.statusDisposable dispose];
        self.statusDisposable = nil;
    }
}

@end
