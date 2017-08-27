//
//  PMBaseLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@interface PMBaseLogic ()
@property (nonatomic, strong) RACCommand *loadDataCommand;
@property (nonatomic, strong) RACCommand *refreshDataCommand;
@property (nonatomic, assign) BOOL isDataLoaded;
@property (nonatomic, strong) RACSubject *performedSegues;
@end

@implementation PMBaseLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isDataLoaded = NO;
        
        self.loadDataCommand = [self createLoadDataCommand];
        self.refreshDataCommand = [self createRefreshDataCommand];
        self.performedSegues = [RACSubject subject];
    }
    return self;
}

- (RACSignal *)loadData
{
    return [RACSignal empty];
}

- (void)startLogic
{
    [self.loadDataCommand execute:self];
}

#pragma mark - commands

- (RACCommand *)createLoadDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[[self loadData]
            doError:^(NSError *error) {
                @strongify(self);
                self.isDataLoaded = NO;
            }]
            doCompleted:^{
                @strongify(self);
                self.isDataLoaded = YES;
            }];
    }];
}

- (RACCommand *)createRefreshDataCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [self loadData];
    }];
}

@end
