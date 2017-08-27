//
//  PMObjectMapperMulti.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMObjectMapper.h"

@interface PMObjectMapperMulti : NSObject <PMObjectMapper>
- (void)registerMapper:(id<PMObjectMapper>)mapper forClass:(Class)responseClass;
@end
