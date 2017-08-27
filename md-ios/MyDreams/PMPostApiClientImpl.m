//
//  PMPostApiClientImpl.m
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostApiClientImpl.h"
#import "PMPostForm.h"
#import "NSDictionary+PM.h"
#import "PMOAuth2APIClient.h"
#import "PMPostResponse.h"
#import "PMPostPhotoResponse.h"
#import "PMFeedsResponse.h"
#import "PMFile.h"
#import "PMFeedCommentsResponse.h"
#import "PMFeedRecommendationsResponse.h"

@implementation PMPostApiClientImpl

- (RACSignal *)getFeeds:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"feed" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedsResponse class]];
}

- (RACSignal *)getPostsWithSearch:(NSString *)search page:(PMPage *)page
{
    if (!search) {
        search = @"";
    }
    NSDictionary *params = @{@"q":search};
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"posts" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedsResponse class]];
}

- (RACSignal *)getFeedsWithDreamer:(NSNumber *)idx page:(PMPage *)page
{
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/feeds", idx];
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:requestPath parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedsResponse class]];
}

- (RACSignal *)createPost:(PMPostForm *)form
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"posts"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:[PMPostResponse class]];
}

- (RACSignal *)getPost:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"posts/%@", idx];
    
    return [self.apiClient requestPath:requestPath
                            parameters:nil
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMPostResponse class]];
}

- (RACSignal *)updatePost:(PMPostForm *)form
{
    NSString *requestPath = [NSString stringWithFormat:@"posts/%@", form.postIdx];
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:requestPath
                            parameters:params
                                method:PMAPIClientHTTPMethodPUT
                    mapResponseToClass:[PMPostResponse class]];
}

- (RACSignal *)removePost:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"posts/%@", idx];
    
    return [self.apiClient requestPath:requestPath
                            parameters:nil
                                method:PMAPIClientHTTPMethodDELETE
                    mapResponseToClass:nil];
}

- (RACSignal *)postPhotos:(UIImage *)photo idx:(NSNumber *)idx progress:(RACSubject *)progress
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        PMFile *photoFile = [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(photo, 0.8f) mimeType:@"image/jpeg"];
        NSMutableDictionary *params = [@{
                                         @"photo":photoFile
                                         } mutableCopy];
        if (idx) {
            params[@"post_id"] = idx;
        }
        
        [subscriber sendNext:params];
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
    
    return [[[signal
        subscribeOn:[RACScheduler scheduler]]
        deliverOn:[RACScheduler mainThreadScheduler]]
        flattenMap:^RACStream *(id params) {
            return [self.apiClient uploadPath:@"post_photos" parameters:params method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMPostPhotoResponse class] progress:progress];
        }];
}

- (RACSignal *)removePhotos:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"post_photos/%@", idx];
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodDELETE mapResponseToClass:nil];
}

- (RACSignal *)getFeedComments:(PMSourceType)sourceType page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    if (sourceType == PMSourceTypeSubscriptions) {
        params = [params mtl_dictionaryByAddingEntriesFromDictionary:@{@"source":@"subscriptions"}];
    }
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"feed/comments" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedCommentsResponse class]];
}

- (RACSignal *)getFeedRecommendations:(PMSourceType)sourceType page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:page error:nil];
    if (sourceType == PMSourceTypeSubscriptions) {
        params = [params mtl_dictionaryByAddingEntriesFromDictionary:@{@"source":@"subscriptions"}];
    }
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"feed/recommendations" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFeedRecommendationsResponse class]];
}

@end
