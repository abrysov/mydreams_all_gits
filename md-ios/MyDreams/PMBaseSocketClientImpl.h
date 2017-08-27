//
//  PMSocketClientImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSocketClient.h"

@class SRWebSocket;
@protocol PMObjectMapper;

@interface PMBaseSocketClientImpl : NSObject <PMBaseSocketClient>
@property (strong, nonatomic) id<PMObjectMapper> objectMapper;

- (instancetype)initWithBaseURL:(NSURL *)url;

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message NS_REQUIRES_SUPER;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket NS_REQUIRES_SUPER;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error NS_REQUIRES_SUPER;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean NS_REQUIRES_SUPER;
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload NS_REQUIRES_SUPER;

@end
