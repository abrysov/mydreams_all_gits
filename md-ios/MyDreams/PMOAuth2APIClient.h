
//
//  PMOAuth2APIClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAPIClient.h"

@class PMOAuthCredential;

@protocol PMOAuth2APIClient <NSObject, PMAPIClient>
@property (assign, nonatomic) BOOL useHTTPBasicAuthentication;

- (void)logout;
- (void)authenticateUsingOAuthWithCredential:(PMOAuthCredential *)credential;

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                     username:(NSString *)username
                                     password:(NSString *)password
                                        scope:(NSString *)scope;

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                 refreshToken:(NSString *)refreshToken;

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                         code:(NSString *)code
                                  redirectURI:(NSString *)uri;

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                       params:(NSDictionary *)params;


@end
