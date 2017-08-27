//
//  PMAuthServiceImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAuthService.h"

@protocol PMOAuth2APIClient;
@protocol PMCredentialStore;
@protocol PMDataFetcher;
@protocol PMUserProvider;
@protocol PMProfileApiClient;

@interface PMAuthServiceImpl : NSObject <PMAuthService>
@property (strong, nonatomic) id<PMOAuth2APIClient> apiClient;
@property (strong, nonatomic) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic) id<PMCredentialStore> credentialStore;
@property (strong, nonatomic) id<PMDataFetcher> dataFetcher;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@end
