//
//  PMUserServiceImpl.h
//  myDreams
//
//  Created by Ivan Ushakov on 28/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserProvider.h"
#import "PMDreamerApiClient.h"
#import "PMStorageService.h"

@protocol PMDataFetcher;

@interface PMUserProviderImpl : NSObject <PMUserProvider>
- (instancetype)initWithStorage:(id<PMStorageService>) storage dataFetcher:(id<PMDataFetcher>)dataFetcher;
@end
