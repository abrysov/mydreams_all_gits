//
//  PMDreamApiClientImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamApiClient.h"
@protocol PMAPIClient;

@interface PMDreamApiClientImpl : NSObject <PMDreamApiClient>
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end
