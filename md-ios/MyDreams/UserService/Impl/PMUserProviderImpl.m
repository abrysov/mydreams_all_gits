//
//  PMUserServiceImpl.m
//  myDreams
//
//  Created by Ivan Ushakov on 28/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserProviderImpl.h"
#import "PMDreamerResponse.h"
#import "PMPersistentMe.h"
#import "PMDataFetcher.h"

@interface PMUserProviderImpl ()
@property (strong, nonatomic) id<PMStorageService> storage;
@property (strong, nonatomic) id<PMDataFetcher> dataFetcher;
@end

@implementation PMUserProviderImpl
@synthesize me, status;

- (instancetype)initWithStorage:(id<PMStorageService>) storage dataFetcher:(id<PMDataFetcher>)dataFetcher;
{
    self = [super init];
    if (self) {
        self.storage = storage;
        self.dataFetcher = dataFetcher;
        
        [self loadFromStorage];
        
        RAC(self, status) = [self.dataFetcher.statusSubject distinctUntilChanged];
        
        @weakify(self);
        [[[RACSignal combineLatest:@[RACObserve(self, me), RACObserve(self, status)]]
            distinctUntilChanged]
            subscribeNext:^(RACTuple *x) {
                @strongify(self);
                if (x.first) {
                    [self saveToStorage:x.first status:x.second];
                }
                else {
                    [self removeFromStorage];
                }
            }];
    }
    
    return self;
}

#pragma mark - private

- (void)loadFromStorage
{
    PMPersistentMe *persistentMe = [[PMPersistentMe allObjects] firstObject];
    //"->" because we observe changes of self.me and self.status and persist it
    self->me = [persistentMe toDreamer];
    self->status = [persistentMe toStatus];
}

- (void)saveToStorage:(PMDreamer *)dreamer status:(PMStatus *)dreamerStatus
{
    [self.storage.storage transactionWithBlock:^{
        PMPersistentMe *persistentMe = [[PMPersistentMe alloc] initWithDreamer:dreamer status:dreamerStatus];
        [self.storage.storage addOrUpdateObject:persistentMe];
    }];
}

- (void)removeFromStorage
{
    PMPersistentMe *persistentMe = [[PMPersistentMe allObjects] firstObject];
    if (persistentMe) {
        [self.storage.storage transactionWithBlock:^{
            [self.storage.storage deleteObject:persistentMe];
        }];
    }
}

@end
