//
//  PMObjectMapperRealm.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMObjectMapperRealm.h"
#import <Realm/Realm.h>
#import <Realm_JSON/RLMObject+JSON.h>
#import "PMStorageService.h"

@implementation PMObjectMapperRealm

- (RACSignal *)mapResponseObject:(id)respObj keyPath:(NSString *)keyPath toClass:(Class)responseClass;
{
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
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
            
            RLMRealm *realm = [RLMRealm defaultRealm];
            
            BOOL sucsess = [realm transactionWithBlock:^{
                
                if ([responseObject isKindOfClass:[NSArray class]]) {
                    result = [responseClass createOrUpdateInRealm:realm withJSONArray:responseObject];
                }
                else {
                    result = [responseClass createOrUpdateInRealm:realm withJSONDictionary:responseObject];
                }
                
            } error:&error];
            
            if (sucsess) {
                [subscriber sendNext:result];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }
        
        return [RACDisposable disposableWithBlock:^{
            if (self.storage.storage.inWriteTransaction) {
                [self.storage.storage cancelWriteTransaction];
            }
        }];
        
    }]
    deliverOn:[RACScheduler mainThreadScheduler]]
    doNext:^(id x) {
        [self.storage.storage refresh];
    }];
}

@end
