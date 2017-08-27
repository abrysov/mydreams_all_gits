//
//  PMPostApiClientImpl.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMPostApiClient.h"

@protocol PMOAuth2APIClient;

@interface PMPostApiClientImpl : NSObject <PMPostApiClient>
@property (strong, nonatomic) id<PMOAuth2APIClient> apiClient;

@end
