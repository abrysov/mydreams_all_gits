//
//  PMDreamersResponse.h
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMDreamer;
@interface PMDreamersResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMDreamer *> *dreamers;
@end
