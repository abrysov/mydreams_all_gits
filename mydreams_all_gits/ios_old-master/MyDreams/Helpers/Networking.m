//
//  Networking.m
//  MyDreams
//
//  Created by Игорь on 30.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Networking.h"
#import <AFNetworking/AFNetworking.h>
#import "Constants.h"

@implementation Networking

+ (void)makeJSONRequestPOST:(NSString *)path parameters:(NSDictionary *)parameters handler:(void (^)(id json))handler {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)makeJSONRequestGET:(NSString *)path handler:(void (^)(id json))handler {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)makeMultipartRequest:(NSString *)path parameters:(NSDictionary *)parameters files:(NSDictionary *)files handler:(void (^)(id json))handler {
    NSString *url = [NSString stringWithFormat:@"%@%@", SERVER_API_URL, path];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //NSURL *filePath = [NSURL fileURLWithPath:@"file://path/to/image.png"];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileURL:filePath name:@"image" error:nil];
        for (id key in files) {
            [formData appendPartWithFileData:[files objectForKey:key] name:key fileName:@"fff" mimeType:@""];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Success: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

@end