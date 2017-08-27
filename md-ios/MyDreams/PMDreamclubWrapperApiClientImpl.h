//
//  PMDreamclubWrapperApiClientImpl.h
//  MyDreams
//
//  Created by user on 10.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamclubWrapperApiClient.h"

@protocol PMPostApiClient;
@protocol PMDreamerApiClient;

@interface PMDreamclubWrapperApiClientImpl : NSObject <PMDreamclubWrapperApiClient>
@property (strong, nonatomic) id<PMPostApiClient> postApiClient;
@property (nonatomic, strong) id<PMDreamerApiClient> dreamerApiClient;
@end
