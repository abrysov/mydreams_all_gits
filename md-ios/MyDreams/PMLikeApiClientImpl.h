//
//  PMApiLikeImpl.h
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLikeApiClient.h"

@protocol PMAPIClient;

@interface PMLikeApiClientImpl : NSObject <PMLikeApiClient>
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end
