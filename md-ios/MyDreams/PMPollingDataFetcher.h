//
//  PMDataFetcher.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDataFetcher.h"

@protocol PMDreamerApiClient;

@interface PMPollingDataFetcher: NSObject <PMDataFetcher>
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@end
