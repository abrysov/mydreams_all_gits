//
//  PMFollowersResponse.h
//  MyDreams
//
//  Created by user on 27.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMDreamer;

@interface PMFollowersResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMDreamer *> *followers;
@end
