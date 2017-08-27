//
//  PMAPIClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PMAPIClientHTTPMethod) {
    PMAPIClientHTTPMethodGET,
    PMAPIClientHTTPMethodHEAD,
    PMAPIClientHTTPMethodPOST,
    PMAPIClientHTTPMethodPUT,
    PMAPIClientHTTPMethodPATCH,
    PMAPIClientHTTPMethodDELETE,
};

extern NSString * const PMAPIClientDidMapErrorNotification;
extern NSString * const PMAPIClientMappedErrorKey;

@protocol PMAPIClient <NSObject>

- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass;
- (RACSignal *)requestPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method keyPath:(NSString *)keyPath mapResponseToClass:(Class)klass;

- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method mapResponseToClass:(Class)klass progress:(RACSubject *)progress;
- (RACSignal *)uploadPath:(NSString *)path parameters:(id)parameters method:(PMAPIClientHTTPMethod)method keyPath:(NSString *)keyPath mapResponseToClass:(Class)klass progress:(RACSubject *)progress;

@end
