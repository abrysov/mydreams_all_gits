//
//  PMPaginationResponseMeta.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMResponseMeta.h"

@interface PMPaginationResponseMeta : PMResponseMeta
@property (assign, readonly, nonatomic) NSUInteger per;
@property (assign, readonly, nonatomic) NSUInteger page;
@property (assign, readonly, nonatomic) NSUInteger totalCount;
@property (assign, readonly, nonatomic) NSUInteger pagesCount;
@property (assign, readonly, nonatomic) NSUInteger remainingCount;
@end
