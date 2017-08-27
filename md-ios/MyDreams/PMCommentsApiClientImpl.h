//
//  PMCommentsApiClientImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCommentsApiClient.h"

@protocol PMBaseSocketClient;

@interface PMCommentsApiClientImpl : NSObject <PMCommentsApiClient>
@property (strong, nonatomic) RACSignal *comments;
@property (strong, nonatomic) RACSignal *reactions;

- (instancetype)initWithSocketClient:(id<PMBaseSocketClient>)socketClient;

@end
