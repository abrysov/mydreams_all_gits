//
//  PMFolloweesResponse.h
//  MyDreams
//
//  Created by user on 29.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMDreamer;

@interface PMFolloweesResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMDreamer *> *dreamers;
@end
