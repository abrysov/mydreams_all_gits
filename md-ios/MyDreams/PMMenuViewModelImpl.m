//
//  PMMenuViewModel.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMenuViewModelImpl.h"
#import "PMDreamer.h"
#import "PMStatus.h"

@interface PMMenuViewModelImpl ()
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *coinsCount;
@property (strong, nonatomic) NSString *messagesCount;
@property (strong, nonatomic) NSString *notificationsCount;
@end

@implementation PMMenuViewModelImpl
@synthesize fullName, coinsCount, messagesCount, notificationsCount, avatar;

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        [[[RACSignal combineLatest:@[RACObserve(self, me), RACObserve(self, status)]]
            distinctUntilChanged]
            subscribeNext:^(RACTuple *x) {
                @strongify(self);
                [self updateWithMe:x.first status:x.second];
            }];
    }
    
    return self;
}

#pragma mark - private

- (void)updateWithMe:(PMDreamer *)me status:(PMStatus *)status
{
    self.fullName = me.fullName;
    
    self.coinsCount = [NSString stringWithFormat:@"%@ %@", @(status.coinsCount), NSLocalizedString(@"menu.menu.coins", nil)];
    
    self.messagesCount = (status.messagesCount > 0) ? [self stringFromUIntegerWithKSuffix:status.messagesCount] : @"";
    self.notificationsCount = (status.notificationsCount > 0) ? [self stringFromUIntegerWithKSuffix:status.notificationsCount] : @"";
}

- (NSString *)stringFromUIntegerWithKSuffix:(NSUInteger) integer
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSString *suffix = @"";
    NSUInteger value = integer;
    
    while (value >= 1000) {
        suffix = [suffix stringByAppendingString:@"k"];
        value /= 1000;
    }
    
    formatter.negativeSuffix = suffix;
    formatter.positiveSuffix = suffix;
    formatter.allowsFloats = NO;
    formatter.minimumIntegerDigits = 1;
    
    return [formatter stringFromNumber:@(value)];
}

@end
