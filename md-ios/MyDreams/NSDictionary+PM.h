//
//  NSDictionary+PM.h
//  MyDreams
//
//  Created by Иван Ушаков on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PM)
- (NSDictionary *)dictionaryByRemovingNullValues;
@end
