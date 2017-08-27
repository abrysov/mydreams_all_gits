//
//  PMSocketClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PMSocketClientDidSendMessage;
extern NSString * const PMSocketClientDidReceiveMessage;
extern NSString * const PMSocketClientDidConnect;
extern NSString * const PMSocketClientDidDisconnect;
extern NSString * const PMSocketClientDidFail;

extern NSString * const PMSocketClientResponseDataKey;
extern NSString * const PMSocketClientCodeKey;
extern NSString * const PMSocketClientReasonKey;
extern NSString * const PMSocketClientErrorKey;

@class PMBaseSocketCommand;
@protocol PMSocketApiClient;

@protocol PMBaseSocketClient <NSObject>

- (void)openSocketWithParams:(NSDictionary *)params;
- (void)closeSocket;
- (RACSignal *)registerCommand:(NSString *)command ofType:(NSString *)type mapResponseToClass:(Class)class;
- (RACSignal *)sendCommand:(PMBaseSocketCommand *)command mapResponseToClass:(Class)class;
- (void)sendCommand:(PMBaseSocketCommand *)command;

@end
