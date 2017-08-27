//
//  PMSocketClient.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketClient.h"

NSString * const PMSocketClientDidSendMessage = @"com.pm.socketClient.message.send";
NSString * const PMSocketClientDidReceiveMessage = @"com.pm.socketClient.message.receive";
NSString * const PMSocketClientDidConnect = @"com.pm.socketClient.connect";
NSString * const PMSocketClientDidDisconnect = @"com.pm.socketClient.disconnect";
NSString * const PMSocketClientDidFail = @"com.pm.socketClient.fail";

NSString * const PMSocketClientResponseDataKey = @"com.pm.socketClient.data";
NSString * const PMSocketClientCodeKey = @"com.pm.socketClient.code";
NSString * const PMSocketClientReasonKey = @"com.pm.socketClient.reason";
NSString * const PMSocketClientErrorKey = @"com.pm.socketClient.error";