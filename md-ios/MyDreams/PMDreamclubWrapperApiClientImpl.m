//
//  PMDreamclubWrapperApiClientImpl.m
//  MyDreams
//
//  Created by user on 10.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamclubWrapperApiClientImpl.h"
#import "PMPage.h"
#import "PMPostApiClient.h"
#import "PMDreamerApiClient.h"
#import "PMDreamclubIdx.h"

@implementation PMDreamclubWrapperApiClientImpl

- (RACSignal *)getDreamclubFeeds:(PMPage *)page
{
    return [self.postApiClient getFeedsWithDreamer:@(kPMDreamclubIdx) page:page];
}

- (RACSignal *)getDreamclub
{
    return [self.dreamerApiClient getDreamer:@(kPMDreamclubIdx)];
}

@end
