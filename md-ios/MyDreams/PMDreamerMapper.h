//
//  PMDreamerMapper.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@class PMPaginationBaseLogic;

@protocol PMDreamerMapper <NSObject>
- (NSArray *)dreamersToViewModels:(NSArray *)dreamers paginationLogic:(PMPaginationBaseLogic *)logic;
- (NSArray *)dreambookDreamersToViewModel:(NSArray *)dreamers;
@end

