//
//  PMSocketClientImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 02.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSocketClientImpl.h"
#import "PMPingSocketMessage.h"

@interface PMSocketClientImpl ()
@property (strong, nonatomic) RACScheduler *scheduler;
@property (strong, nonatomic) RACDisposable *pingDisposable;
@end

@implementation PMSocketClientImpl

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.scheduler = [RACScheduler schedulerWithPriority:RACSchedulerPriorityDefault name:NSStringFromClass(self.class)];
    }
    
    return self;
}

- (void)dealloc
{
    [self stopPing];
}

- (void)openSocketWithToken:(NSString *)token
{
    [self openSocketWithParams:@{@"token": token}];
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    [super webSocketDidOpen:webSocket];
    [self startPing];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    [super webSocket:webSocket didCloseWithCode:code reason:reason wasClean:wasClean];
    [self stopPing];
}

#pragma mark - private

- (void)startPing
{
    @weakify(self);
    
    if (!self.pingDisposable) {
        self.pingDisposable = [self.scheduler after:[NSDate date] repeatingEvery:30.0f withLeeway:5.0f schedule:^{
            @strongify(self);
            [self sendPing];
        }];
    }
}

- (void)stopPing
{
    if (self.pingDisposable) {
        [self.pingDisposable dispose];
        self.pingDisposable = nil;
    }
}

- (void)sendPing
{
    [self sendCommand:[[PMPingSocketMessage alloc] init]];
}

@end
