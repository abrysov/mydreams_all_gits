//
//  PMPaginationBaseLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 27.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

@class PMBaseModel;
@class PMPage;

@interface PMPaginationBaseLogic : PMBaseLogic
@property (assign, nonatomic, readonly) BOOL hasNextPage;
@property (strong, nonatomic, readonly) RACCommand *loadNextPage;
@property (strong, nonatomic, readonly) PMPage *currentPage;
@property (strong, nonatomic, readonly) NSArray<PMBaseModel *> *items;
@property (assign, nonatomic, readonly) NSInteger totalCount;
@property (assign, nonatomic) BOOL ignoreDataEmpty;
@end
