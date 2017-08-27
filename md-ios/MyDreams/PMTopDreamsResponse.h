//
//  PMTopDreamsResponse.h
//  MyDreams
//
//  Created by user on 24.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMTopDream;

@interface PMTopDreamsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMTopDream *> *dreams;
@end
