//
//  PMLikesResponse.h
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMLike;

@interface PMLikesResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMLike *> *likes;
@end
