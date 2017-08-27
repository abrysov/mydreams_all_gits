//
//  PMObjectMapper.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMObjectMapper <NSObject>
- (RACSignal *)mapResponseObject:(id)responseObject keyPath:(NSString *)keyPath toClass:(Class)responseClass;
@end
