//
//  PMAPIClientWithStubs.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMOAuth2APIClientStub.h"
#import <Mocktail/Mocktail.h>
#import <AFNetworking/AFNetworking.h>

@implementation PMOAuth2APIClientStub

- (instancetype)initWithBaseURL:(NSURL *)baseUrl
                  configuration:(NSURLSessionConfiguration *)configuration
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
{
    [Mocktail startWithContentsOfDirectoryAtURL:[[NSBundle mainBundle] resourceURL] configuration:configuration];
    return [super initWithBaseURL:baseUrl configuration:configuration clientID:clientID secret:secret];
}

@end
