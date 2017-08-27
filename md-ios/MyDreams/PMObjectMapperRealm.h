//
//  PMObjectMapperRealm.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMObjectMapper.h"

@protocol PMStorageService;

@interface PMObjectMapperRealm : NSObject<PMObjectMapper>
@property (strong, nonatomic) id<PMStorageService> storage;
@end
