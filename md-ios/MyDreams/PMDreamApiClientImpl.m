//
//  PMDreamApiClientImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamApiClientImpl.h"
#import "PMAPIClient.h"
#import "PMDreamResponse.h"
#import "PMDreamsResponse.h"
#import "PMTopDreamsResponse.h"
#import "PMDreamFilterForm.h"
#import "PMPage.h"
#import "NSDictionary+PM.h"
#import "PMDreamForm.h"

@implementation PMDreamApiClientImpl

- (RACSignal *)getDream:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"dreams/%@", idx];
    
    return [self.apiClient requestPath:requestPath
                            parameters:nil
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMDreamResponse class]];
}

- (RACSignal *)updateDream:(PMDreamForm *)form progress:(RACSubject *)progress
{
    NSString *requestPath = [NSString stringWithFormat:@"dreams/%@", form.dreamIdx];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:&error];
        params = [params dictionaryByRemovingNullValues];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
        subscribeOn:[RACScheduler scheduler]]
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(id params) {
            return [self.apiClient uploadPath:requestPath parameters:params method:PMAPIClientHTTPMethodPUT mapResponseToClass:[PMDreamResponse class] progress:progress];
        }];
}

- (RACSignal *)removeDream:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"dreams/%@", idx];
    
    return [self.apiClient requestPath:requestPath
                            parameters:nil
                                method:PMAPIClientHTTPMethodDELETE
                    mapResponseToClass:nil];
}

- (RACSignal *)getDreams:(PMDreamFilterForm *)form page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"dreams"
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMDreamsResponse class]];
}

- (RACSignal *)getOwnDreams:(PMDreamFilterForm *)form page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"profile/dreams"
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMDreamsResponse class]];
}

- (RACSignal *)getTopDreams:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"top/dreams"
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMTopDreamsResponse class]];
}

- (RACSignal *)createDream:(PMDreamForm *)form progress:(RACSubject *)progress
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:&error];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
        subscribeOn:[RACScheduler scheduler]]
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(id params) {
            return [self.apiClient uploadPath:@"dreams" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:nil progress:progress];
        }];
}

- (RACSignal *)getDreamsOfDreamer:(NSNumber *)index form:(PMDreamFilterForm *)form page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/dreams", index];
    
    return [self.apiClient requestPath:requestPath
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMDreamsResponse class]];
}

@end
