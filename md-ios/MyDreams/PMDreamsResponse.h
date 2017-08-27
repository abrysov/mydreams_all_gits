//
//  PMDreamsResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMDream;

@interface PMDreamsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMDream *> *dreams;
@end
