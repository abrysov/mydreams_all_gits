//
//  PMDreamerServiceImpl.h
//  myDreams
//
//  Created by Ivan Ushakov on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerApiClient.h"

@protocol PMAPIClient;

@interface PMDreamerApiClientImpl : NSObject <PMDreamerApiClient>
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end
