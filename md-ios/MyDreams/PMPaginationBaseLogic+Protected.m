//
//  PMPaginationBaseLogic+Protected.m
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic+Protected.h"

@interface PMPaginationBaseLogic ()
@property (strong, nonatomic, readwrite) NSArray<PMBaseModel *> *items;
@end

@implementation PMPaginationBaseLogic (Protected)

- (void)appendItem:(PMBaseModel *)item atIndex:(NSUInteger)index
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array insertObject:item atIndex:index];
    self.items = [NSArray arrayWithArray:array];
}

- (void)updateItem:(PMBaseModel *)item
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.items];
    [array replaceObjectAtIndex:[self.items indexOfObject:item] withObject:item];
    self.items = [NSArray arrayWithArray:array];
}

- (void)removeItemAtIndex:(NSUInteger)index
{
    NSMutableArray *array = [self.items mutableCopy];
    [array removeObjectAtIndex:index];
    self.items = [array copy];
}

@end
