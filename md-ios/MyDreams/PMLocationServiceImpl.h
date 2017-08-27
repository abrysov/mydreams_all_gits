//
//  PMLocationServiceImpl.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMAPIClient.h"
#import "PMLocationService.h"

@interface PMLocationServiceImpl : NSObject <PMLocationService>
@property (strong, nonatomic) id<PMAPIClient> apiClient;
@end
