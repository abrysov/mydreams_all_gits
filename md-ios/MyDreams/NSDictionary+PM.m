//
//  NSDictionary+PM.m
//  MyDreams
//
//  Created by Иван Ушаков on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "NSDictionary+PM.h"

@implementation NSDictionary (PM)

- (NSDictionary *)dictionaryByRemovingNullValues
{
    __block NSMutableDictionary *mutableDictionary = [self mutableCopy];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isEqual:[NSNull null]]) {
            [mutableDictionary removeObjectForKey:key];
        }
    }];
    
    return [NSDictionary dictionaryWithDictionary:mutableDictionary];
}

@end
