//
//  Networking.h
//  MyDreams
//
//  Created by Игорь on 30.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#ifndef MyDreams_Networking_h
#define MyDreams_Networking_h

@interface Networking : NSObject

+ (void)makeJSONRequestPOST:(NSString *)path parameters:(NSDictionary *)parameters handler:(void (^)(id json))handler;
+ (void)makeJSONRequestGET:(NSString *)path handler:(void (^)(id json))handler;
+ (void)makeMultipartRequest:(NSString *)path parameters:(NSDictionary *)parameters files:(NSDictionary *)files handler:(void (^)(id json))handler;

@end

#endif
