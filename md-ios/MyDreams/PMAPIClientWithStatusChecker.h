//
//  PMAPIClientWithStatusChecker.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAPIClient.h"

@protocol PMApplicationRouter;
@protocol PMAuthService;

@interface PMAPIClientWithStatusChecker : NSObject <PMAPIClient>
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (weak, nonatomic) id<PMAuthService> authService;

- (instancetype)initWithApiClient:(id<PMAPIClient>)apiClient;
@end
