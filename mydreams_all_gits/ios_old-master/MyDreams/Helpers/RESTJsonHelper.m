//
//  RESTJsonHelper.m
//  Unicom
//
//  Created by Игорь on 16.01.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RESTJsonHelper.h"
#import "Strings.h"
#import "Constants.h"
#import "CommonResponseModel.h"
#import "JSONHTTPClient.h"
#import "AppDelegate.h"
#import <AFNetworking/AFNetworking.h>

@implementation RESTJsonHelper

+ (void)makeJSONRequestPOST:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json handler:(RESTJsonHelperHandler)handler {
	NSLog(@" ---- makeJSONRequestPOST");
	NSLog(@"uri: %@", uri);
	NSLog(@"json: %@", json);
	NSLog(@"token: %@", token);

	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

	[headers setObject:@"application/json" forKey:@"Accept"];
	if (token)
		[headers setObject:token forKey:@"Authorization"];
	[headers setObject:@"application/json" forKey:@"Content-type"];

	//__weak __typeof(handler) weakHandler = handler;
	[JSONHTTPClient JSONFromURLWithString:uri
	                               method:kHTTPMethodPOST
	                               params:params
	                           orBodyData:[NSJSONSerialization dataWithJSONObject:json options:0 error:nil]
	                              headers:headers
	                           completion: ^(id json, JSONModelError *err) {
	    NSLog(@"Got json: %@", json);
	    //__strong __typeof(weakHandler) strongHandler = weakHandler;
	    NSString *errMsg;
	    if (err)
			errMsg = NSLocalizedString(@"_ERROR_DATA_NOT_RECEIVED", @"");
	    handler(json, errMsg);
	}];
}

+ (void)makeJSONRequestPUT:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json handler:(RESTJsonHelperHandler)handler {
	NSLog(@" ---- makeJSONRequestPUT");
	NSLog(@"uri: %@", uri);
	NSLog(@"json: %@", json);
	NSLog(@"token: %@", token);

	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

	[headers setObject:@"application/json" forKey:@"Accept"];
	if (token)
		[headers setObject:token forKey:@"Authorization"];
	[headers setObject:@"application/json" forKey:@"Content-type"];

	//__weak __typeof(handler) weakHandler = handler;
	[JSONHTTPClient JSONFromURLWithString:uri
	                               method:@"PUT"
	                               params:params
	                           orBodyData:[NSJSONSerialization dataWithJSONObject:json options:0 error:nil]
	                              headers:headers
	                           completion: ^(id json, JSONModelError *err) {
	    NSLog(@"Got json: %@", json);
	    //__strong __typeof(weakHandler) strongHandler = weakHandler;
	    NSString *errMsg;
	    if (err)
			errMsg = NSLocalizedString(@"_ERROR_DATA_NOT_RECEIVED", @"");
	    handler(json, errMsg);
	}];
}

+ (void)makeJSONRequestGET:(NSString *)uri token:(NSString *)token handler:(RESTJsonHelperHandler)handler {
	NSLog(@" ---- makeJSONRequestGET");
	NSLog(@"uri: %@", uri);
	NSLog(@"token: %@", token);

	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

	[headers setObject:@"application/json" forKey:@"Accept"];
	if (token)
		[headers setObject:token forKey:@"Authorization"];
	[headers setObject:@"application/json" forKey:@"Content-type"];

	//__weak __typeof(handler) weakHandler = handler;
	[JSONHTTPClient JSONFromURLWithString:uri
	                               method:kHTTPMethodGET
	                               params:params
	                           orBodyData:nil
	                              headers:headers
	                           completion: ^(id json, JSONModelError *err) {
	    NSLog(@"Got json: %@", json);
	    //__strong __typeof(weakHandler) strongHandler = weakHandler;
	    NSString *errMsg;
	    if (err)
			errMsg = NSLocalizedString(@"_ERROR_DATA_NOT_RECEIVED", @"");
	    handler(json, errMsg);
	}];
}

+ (void)makeMultipartRequest:(NSString *)uri token:(NSString *)token json:(NSDictionary *)json files:(NSDictionary *)files handler:(RESTJsonHelperHandler)handler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    // todo: передавать разные файлы
    [manager POST:uri parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (id key in files) {
            [formData appendPartWithFileData:[files objectForKey:key] name:key fileName:@"image.jpg" mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        handler(responseObject, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        handler(nil, error.description);
    }];
}

//+ (void)retrieveJSONObjectViaPOST:(NSString *)uri json:(NSDictionary *)json handler:(void (^)(id json))handler {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSString *token = [defaults stringForKey:@"token"];
//
//	[self makeJSONRequestPOST:uri token:token json:json handler: ^(id json, NSString *err) {
//	    if (err == nil) {
//	        id <CommonResponse> responseData = [self handleJSONResponse:json class:[CommonResponseModel class] error:&err];
//	        if (responseData != nil && err == nil) {
//	            handler([json objectForKey:@"body"]);
//			}
//		}
//	}];
//}
//
//+ (void)retrieveJSONObjectViaGET:(NSString *)uri handler:(void (^)(id json))handler {
//	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//	NSString *token = [defaults stringForKey:@"token"];
//
//	[self makeJSONRequestGET:uri token:token handler: ^(id json, NSString *err) {
//	    if (err == nil) {
//	        id <CommonResponse> responseData = [self handleJSONResponse:json class:[CommonResponseModel class] error:&err];
//	        if (responseData != nil && err == nil) {
//	            handler([json objectForKey:@"body"]);
//			}
//		}
//	}];
//}
//
//+ (id <CommonResponse> )handleJSONResponse:(id)json class:(Class)class error:(NSString **)err {
//	NSError *jsonError = nil;
//	id <CommonResponse> responseModel = (id <CommonResponse> )[[class alloc] initWithDictionary : json error : &jsonError];
//	if (jsonError || !responseModel) {
//		return nil;
//	}
//	NSString *message = responseModel.message;
//	NSString *error = nil;
//	switch (responseModel.code) {
//		case 0:
//			// все ок
//			break;
//            
//        case 1:
//            error = message;
//            break;
//            
//		default:
//			break;
//	}
//	if (error != nil) {
//		NSLog(@"json response error %@", error);
//		if (err)
//			*err = error;
//
//		//
//	}
//	return responseModel;
//}

@end
