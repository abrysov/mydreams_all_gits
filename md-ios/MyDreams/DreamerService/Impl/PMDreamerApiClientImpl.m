//
//  PMDreamerServiceImpl.m
//  myDreams
//
//  Created by Ivan Ushakov on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerApiClientImpl.h"
#import "PMAPIClient.h"
#import "PMDreamerResponse.h"
#import "PMStatusResponse.h"
#import "PMDreamersResponse.h"
#import "PMAvatarResponse.h"
#import "PMFriendsResponse.h"
#import "NSDictionary+PM.h"
#import "PMFriendshipRequestResponse.h"
#import "PMDreambookBackgroundResponse.h"
#import "PMPhotosResponse.h"
#import "PMPostPhotoResponse.h"
#import "PMFeedsResponse.h"
#import "PMFile.h"

@interface PMDreamerApiClientImpl ()
@end

@implementation PMDreamerApiClientImpl

- (RACSignal *)getDreamer:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@", idx];
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMDreamerResponse class]];
}

- (RACSignal *)getStatus
{
    return [self.apiClient requestPath:@"profile/status" parameters:nil method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMStatusResponse class]];
}

- (RACSignal *)postDreambookBackground:(PMImageForm *)form progress:(RACSubject *)progress
{
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
    
    return [signal flattenMap:^RACStream *(id params) {
        return [self.apiClient uploadPath:@"profile/dreambook_bg" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMDreambookBackgroundResponse class] progress:progress];
    }];
}

- (RACSignal *)postAvatar:(PMImageForm *)avatar progress:(RACSubject *)progress
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:avatar error:&error];
        
        if (error) {
            [subscriber sendError:error];
        }
        else {
            [subscriber sendNext:params];
            [subscriber sendCompleted];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [signal flattenMap:^RACStream *(id params) {
        return [self.apiClient uploadPath:@"profile/avatar" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMAvatarResponse class] progress:progress];
    }];
}

- (RACSignal *)getFeeds:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/feeds", idx];
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedsResponse class]];
}

- (RACSignal *)getPhotos:(NSNumber *)idx page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    params = [params dictionaryByRemovingNullValues];
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/photos", idx];
    return [self.apiClient requestPath:requestPath parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMPhotosResponse class]];
}

- (RACSignal *)removePhotos:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"post_photos/%@", idx];
    
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodDELETE mapResponseToClass:nil];
}

- (RACSignal *)getDreamers:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];

    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"dreamers"
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMDreamersResponse class]];
}



@end
