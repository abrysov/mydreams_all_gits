//
//  PMOAuth2APIClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMOAuth2APIClient.h"
#import "PMAPIClientImpl.h"
#import "PMOAuthCredential.h"

@interface PMOAuth2APIClientImpl : PMAPIClientImpl <PMOAuth2APIClient>

- (instancetype)initWithBaseURL:(NSURL *)baseUrl
                  configuration:(NSURLSessionConfiguration *)configuration
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret;

@end
