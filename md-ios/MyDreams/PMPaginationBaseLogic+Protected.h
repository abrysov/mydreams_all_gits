//
//  PMPaginationBaseLogic+Protected.h
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@interface PMPaginationBaseLogic (Protected)
- (void)appendItem:(PMBaseModel *)item atIndex:(NSUInteger)index;
- (void)updateItem:(PMBaseModel *)item;
- (void)removeItemAtIndex:(NSUInteger)index;
@end
