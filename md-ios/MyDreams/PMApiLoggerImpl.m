//
//  PMApiLogger.m
//  MyDreams
//
//  Created by Иван Ушаков on 05.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMApiLoggerImpl.h"
#import <AFNetworking/AFNetworking.h>
#import "PMAPIClient.h"
#import "PMSocketClient.h"

@implementation PMApiLoggerImpl

- (void)dealloc
{
    [self stopLogging];
}

#pragma mark - public


- (void)startLogging
{
    [self stopLogging];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidStart:) name:AFNetworkingTaskDidResumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkRequestDidFinish:) name:AFNetworkingTaskDidCompleteNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didMapErrorNotificationReceived:) name:PMAPIClientDidMapErrorNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidSendMessage:) name:PMSocketClientDidSendMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidSendReceiveMessage:) name:PMSocketClientDidReceiveMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidConnect:) name:PMSocketClientDidConnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidDisconnect:) name:PMSocketClientDidDisconnect object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketDidFail:) name:PMSocketClientDidFail object:nil];
}

- (void)stopLogging
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - http

- (void)networkRequestDidStart:(NSNotification *)notification
{
    NSURLRequest *request = [self networkRequestFromNotification:notification];
    if (!request) return;
    
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"-> %@ %@\n\nHeaders:\n%@\n\nBody:\n%@\n", request.HTTPMethod, request.URL.absoluteString, request.allHTTPHeaderFields, body);
}

- (void)networkRequestDidFinish:(NSNotification *)notification
{
    NSURLRequest *request = [self networkRequestFromNotification:notification];
    NSURLResponse *response = [notification.object response];
    NSError *error = [self networkErrorFromNotification:notification];
    if (!request && !response) return;

    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }

    id responseObject = nil;
    if (notification.userInfo) {
        NSData *responseData = notification.userInfo[AFNetworkingTaskDidCompleteResponseDataKey];
        if (responseData) {
            responseObject = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        } else {
            responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
        }
    }
    
    if (!error) {
        NSLog(@"<- %@ %@ (%ld)\n\nHeaders:\n%@\n\nResponse:\n%@\n", request.HTTPMethod, request.URL.absoluteString, (long)responseStatusCode, responseHeaderFields, responseObject);
    }
}

- (void)didMapErrorNotificationReceived:(NSNotification *)notification
{
    NSError *error = notification.userInfo[PMAPIClientMappedErrorKey];
    NSError *initialError = error.userInfo[NSUnderlyingErrorKey];
    NSHTTPURLResponse *response;
    if (initialError) {
        response = initialError.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    } else {
        response = error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey];
    }
    if (response) {
        NSLog(@"<- %@ ERROR (%ld)\n\n%@\n", response.URL.absoluteString, (long)response.statusCode, error);
    } else {
        NSString *path = initialError.userInfo[NSURLErrorFailingURLStringErrorKey] ?: error.userInfo[NSURLErrorFailingURLStringErrorKey];
        NSLog(@"<- %@ ERROR\n\n%@\n", path, error);
    }
}

#pragma mark - socket

- (void)socketDidSendMessage:(NSNotification *)notification
{
    id  data = [notification.userInfo objectForKey:PMSocketClientResponseDataKey];
    if ([data isKindOfClass:[NSData class]]) {
        data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
        
    NSLog(@"-> web socket:\n %@", data);
}

- (void)socketDidSendReceiveMessage:(NSNotification *)notification
{
    id data = [notification.userInfo objectForKey:PMSocketClientResponseDataKey];
    if ([data isKindOfClass:[NSData class]]) {
        data = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSLog(@"<- web socket:\n %@", data);
}

- (void)socketDidConnect:(NSNotification *)notification
{
    NSLog(@"--! web socket did connect");
}

- (void)socketDidDisconnect:(NSNotification *)notification
{
    NSLog(@"--! web socket did disconnect with\ncode: %@\nreason: %@",
          notification.userInfo[PMSocketClientCodeKey],
          notification.userInfo[PMSocketClientReasonKey]);
}

- (void)socketDidFail:(NSNotification *)notification
{
    NSLog(@"--! web socket did fail with error: %@", notification.userInfo[PMSocketClientErrorKey]);
}


#pragma mark - private

- (NSURLRequest *)networkRequestFromNotification:(NSNotification *)notification
{
    NSURLRequest *request = nil;
    if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    } else if ([[notification object] respondsToSelector:@selector(request)]) {
        request = [[notification object] request];
    }
    return request;
}

- (NSError *)networkErrorFromNotification:(NSNotification *)notification
{
    NSError *error = nil;

    if ([[notification object] isKindOfClass:[NSURLSessionTask class]]) {
        error = [(NSURLSessionTask *)[notification object] error];
        if (!error) {
            error = notification.userInfo[AFNetworkingTaskDidCompleteErrorKey];
        }
    }
    
    return error;
}

@end
