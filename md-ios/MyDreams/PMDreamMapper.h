//
//  PMDreamMapper.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@class PMPaginationBaseLogic;

@protocol PMDreamMapper <NSObject>
- (NSArray *)dreamsToViewModels:(NSArray *)dreams paginationLogic:(PMPaginationBaseLogic *)logic;
@end
