//
//  RESTJsonHelper.h
//  Unicom
//
//  Created by Игорь on 16.01.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseModel.h"

typedef void (^RESTJsonHelperHandler)(id json, NSString *err);

@interface RESTJsonHelper : NSObject
+ (void)makeJSONRequestPOST:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json handler:(RESTJsonHelperHandler)handler;
+ (void)makeJSONRequestPUT:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json handler:(RESTJsonHelperHandler)handler;
+ (void)makeJSONRequestGET:(NSString *)uri token:(NSString *)token handler:(RESTJsonHelperHandler)handler;
+ (void)makeMultipartRequest:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json files:(NSDictionary *)files handler:(RESTJsonHelperHandler)handler;
//+ (void)retrieveJSONObjectViaPOST:(NSString *)uri json:(NSString *)json handler:(void (^)(id json))handler;
//+ (void)retrieveJSONObjectViaGET:(NSString *)uri handler:(void (^)(id json))handler;
//+ (id <CommonResponse> )handleJSONResponse:(id)json class:(Class)class error:(NSString **)error;
@end
