//
//  PMObjectMapperMantle.m
//  MyDreams
//
//  Created by Иван Ушаков on 25.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMObjectMapperMantle.h"
#import <Mantle/Mantle.h>

@implementation PMObjectMapperMantle

- (RACSignal *)mapResponseObject:(id)respObj keyPath:(NSString *)keyPath toClass:(Class)responseClass;
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        id responseObject = respObj;
        
        if (responseObject && keyPath && keyPath.length > 0) {
            responseObject = [responseObject valueForKeyPath:keyPath];
        }
        
        if (!responseObject || !responseClass) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
        }
        else {
            
            NSError *error;
            __block id result = nil;
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                result = [MTLJSONAdapter modelsOfClass:responseClass fromJSONArray:responseObject error:&error];
            }
            else {
                result = [MTLJSONAdapter modelOfClass:responseClass fromJSONDictionary:responseObject error:&error];
            }
            
            if (!error) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }
        
        return [RACDisposable disposableWithBlock:^{
        }];
        
    }];
}

@end
