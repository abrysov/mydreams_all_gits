//
//  PMCommentsApiClientImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCommentsApiClientImpl.h"
#import "PMSocketClient.h"
#import "PMListCommentsCommand.h"
#import "PMSubscribeCommentsCommand.h"
#import "PMUnsubscribeCommentsCommand.h"
#import "PMPostCommentsCommand.h"
#import "PMAddReactionCommentsCommand.h"
#import "PMComment.h"
#import "PMReaction.h"
#import "PMCommentsResponse.h"

@interface PMCommentsApiClientImpl()
@property (strong, nonatomic) id<PMBaseSocketClient> socketClient;
@end

@implementation PMCommentsApiClientImpl

- (instancetype)initWithSocketClient:(id<PMBaseSocketClient>)socketClient
{
    self = [super init];
    if (self) {
        self.socketClient = socketClient;
        
        self.comments = [self.socketClient registerCommand:@"comment" ofType:@"comments" mapResponseToClass:[PMComment class]];
        self.reactions = [self.socketClient registerCommand:@"add_reaction" ofType:@"comments" mapResponseToClass:[PMReaction class]];
    }
    
    return self;
}

- (RACSignal *)requestCommentsListForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx page:(PMPage *)page
{
    PMBaseSocketCommand *command = [[PMListCommentsCommand alloc] initWithResourceType:resourceType resourceIdx:resourceIdx page:page];
    return [self.socketClient sendCommand:command mapResponseToClass:[PMCommentsResponse class]];
}

- (void)subscribeToCommentsForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
{
    PMBaseSocketCommand *command = [[PMSubscribeCommentsCommand alloc] initWithResourceType:resourceType resourceIdx:resourceIdx];
    [self.socketClient sendCommand:command];
}

- (void)unsubscribeFromCommentsForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
{
    PMBaseSocketCommand *command = [[PMUnsubscribeCommentsCommand alloc] initWithResourceType:resourceType resourceIdx:resourceIdx];
    [self.socketClient sendCommand:command];
}

- (void)postComment:(NSString *)message forResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
{
    PMBaseSocketCommand *command = [[PMPostCommentsCommand alloc] initWithResourceType:resourceType resourceIdx:resourceIdx body:message];
    [self.socketClient sendCommand:command];
}

- (void)addReaction:(NSString *)reaction forCommentWithIdx:(NSNumber *)commentIdx
{
    PMBaseSocketCommand *command = [[PMAddReactionCommentsCommand alloc] initWithCommentIdx:commentIdx body:reaction];
    [self.socketClient sendCommand:command];
}

@end
