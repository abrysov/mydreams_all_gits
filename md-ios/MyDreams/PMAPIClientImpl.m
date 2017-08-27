//
//  PMAPIClientImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAPIClientImpl.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import "PMObjectMapper.h"
#import "PMNetworkErrorMapper.h"
#import "PMFile.h"

@interface AFStreamingMultipartFormData : NSObject <AFMultipartFormData>
- (instancetype)initWithURLRequest:(NSMutableURLRequest *)urlRequest
                    stringEncoding:(NSStringEncoding)encoding;

- (NSMutableURLRequest *)requestByFinalizingMultipartFormData;
@end

@interface PMAPIClientImpl ()
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@end

@implementation PMAPIClientImpl

- (instancetype)initWithBaseURL:(NSURL *)baseUrl configuration:(NSURLSessionConfiguration *)configuration
{
    self = [super init];
    if (self) {
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;

        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseUrl sessionConfiguration:configuration];
        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI = [NSSet setWithArray:@[@"GET", @"HEAD"]];
        
        NSString *lang = [[NSLocale preferredLanguages] firstObject];
        [self.sessionManager.requestSerializer setValue:lang forHTTPHeaderField:@"Accept-Language"];
    }
    return self;
}

- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass
{
    return [self requestPath:path parameters:parameters method:method keyPath:nil mapResponseToClass:klass];
}

- (RACSignal *)requestPath:(NSString *)path
                parameters:(id)parameters
                    method:(PMAPIClientHTTPMethod)method
                   keyPath:(NSString *)keyPath
        mapResponseToClass:(Class)klass
{
    RACSignal *signal = [self requestPath:path parameters:parameters method:method];
    signal = [signal deliverOn:[RACScheduler scheduler]];
    signal = [self mapErrors:signal];
    signal = [self mapResponse:signal keyPath:keyPath toClass:klass];
    signal = [signal deliverOn:[RACScheduler mainThreadScheduler]];
    return signal;
}

- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass progress:(RACSubject *)progress
{
    return [self uploadPath:path parameters:parameters method:method keyPath:nil mapResponseToClass:klass progress:progress];
}

- (RACSignal *)uploadPath:(NSString *)path
               parameters:(id)parameters
                   method:(PMAPIClientHTTPMethod)method
                  keyPath:(NSString *)keyPath
       mapResponseToClass:(Class)klass
                 progress:(RACSubject *)progress
{
    RACSignal *signal = [self uploadPath:path parameters:parameters method:method progress:progress];
    signal = [signal deliverOn:[RACScheduler scheduler]];
    signal = [self mapErrors:signal];
    signal = [self mapResponse:signal keyPath:keyPath toClass:klass];
    signal = [signal deliverOn:[RACScheduler mainThreadScheduler]];
    return signal;
}

- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method
{
    @weakify(self);
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSURLRequest *request = [self.sessionManager.requestSerializer requestWithMethod:[self httpMethodToString:method]
                                                                               URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString]
                                                                              parameters:parameters
                                                                                   error:nil];
        
        NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:RACTuplePack(responseObject, response)];
                [subscriber sendCompleted];
            }
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method progress:(RACSubject *)progress;
{
    @weakify(self);
    return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
        @strongify(self);
        
        NSMutableURLRequest *mutableRequest = [self.sessionManager.requestSerializer requestWithMethod:[self httpMethodToString:method]
                                                                                             URLString:[[NSURL URLWithString:path relativeToURL:self.sessionManager.baseURL] absoluteString]
                                                                                            parameters:nil
                                                                                                 error:nil];
        
        NSURLRequest *request = [self multipartFormDataRequestFromParams:parameters request:mutableRequest];
        
        NSURLSessionDataTask *task = [self.sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                [progress sendNext:uploadProgress];
            }
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:RACTuplePack(responseObject, response)];
                [subscriber sendCompleted];
            }
            
            if (progress) {
                [progress sendCompleted];
            }
        }];
        
        [task resume];
    
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}

#pragma mark - private

- (NSURLRequest *)multipartFormDataRequestFromParams:(id)parameters request:(NSMutableURLRequest *)request
{
    __block AFStreamingMultipartFormData *formData = [[AFStreamingMultipartFormData alloc] initWithURLRequest:request stringEncoding:NSUTF8StringEncoding];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[PMFile class]]) {
            PMFile *file = (PMFile *)obj;
            [formData appendPartWithFileData:file.data name:key fileName:file.name mimeType:file.mimeType];
            return;
        }
        
        NSData *data = nil;
        if ([obj isKindOfClass:[NSData class]]) {
            data = obj;
        } else if ([obj isEqual:[NSNull null]]) {
            data = [NSData data];
        } else {
            data = [[obj description] dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        if (data) {
            [formData appendPartWithFormData:data name:key];
        }
    }];
    
    return [formData requestByFinalizingMultipartFormData];
}

- (RACSignal *)mapErrors:(RACSignal *)signal
{
    @weakify(self);
    return [signal catch:^RACSignal *(NSError *error) {
        @strongify(self);
        NSError *mappedError = [self.errorMapper mapNetworkError:error];
        [[NSNotificationCenter defaultCenter] postNotificationName:PMAPIClientDidMapErrorNotification object:self userInfo:@{PMAPIClientMappedErrorKey:mappedError}];
        return [RACSignal error:mappedError];
    }];
}

- (RACSignal *)mapResponse:(RACSignal *)signal keyPath:(NSString *)keyPath toClass:(Class)klass
{
    @weakify(self);
    return [signal flattenMap:^RACStream *(RACTuple *x) {
        @strongify(self);
        id responseObject = x.first;
        return [self.objectMapper mapResponseObject:responseObject keyPath:keyPath toClass:klass];
    }];
}

#pragma mark - mapping

- (NSString *)httpMethodToString:(PMAPIClientHTTPMethod)method
{
    switch (method) {
        case PMAPIClientHTTPMethodGET:
            return @"GET";
        case PMAPIClientHTTPMethodHEAD:
            return @"HEAD";
        case PMAPIClientHTTPMethodPOST:
            return @"POST";
        case PMAPIClientHTTPMethodPUT:
            return @"PUT";
        case PMAPIClientHTTPMethodPATCH:
            return @"PATCH";
        case PMAPIClientHTTPMethodDELETE:
            return @"DELETE";
    }
}

@end
