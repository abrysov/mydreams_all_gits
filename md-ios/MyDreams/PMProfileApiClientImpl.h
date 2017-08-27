//
//  PMProfileApiClientImpl.h
//  MyDreams
//
//  Created by user on 01.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMProfileApiClient.h"

@protocol  PMOAuth2APIClient;

@interface PMProfileApiClientImpl : NSObject <PMProfileApiClient>
@property (strong, nonatomic) id<PMOAuth2APIClient> apiClient;
@end
