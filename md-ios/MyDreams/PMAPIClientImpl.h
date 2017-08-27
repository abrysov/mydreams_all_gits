//
//  PMAPIClientImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAPIClient.h"

@protocol PMObjectMapper;
@protocol PMNetworkErrorMapper;
@class AFHTTPSessionManager;

@interface PMAPIClientImpl : NSObject<PMAPIClient>
@property (strong, nonatomic) id<PMObjectMapper> objectMapper;
@property (strong, nonatomic) id<PMNetworkErrorMapper> errorMapper;
@property (strong, nonatomic, readonly) AFHTTPSessionManager *sessionManager;

- (instancetype)initWithBaseURL:(NSURL *)baseUrl configuration:(NSURLSessionConfiguration *)configuration;
- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method;
- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method progress:(RACSubject *)progress;

@end
