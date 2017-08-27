//
//  PMFriendsApiClientImpl.m
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendsApiClientImpl.h"
#import "PMFriendshipRequestResponse.h"
#import "PMFriendshipRequestsResponse.h"
#import "PMFriendsResponse.h"
#import "PMFollowersResponse.h"
#import "PMFolloweesResponse.h"
#import "PMPage.h"
#import "PMDreamerFilterForm.h"
#import "PMApiClient.h"
#import "NSDictionary+PM.h"

@implementation PMFriendsApiClientImpl

- (RACSignal *)createFriendshipRequest:(NSNumber *)idx
{
    return [self.apiClient requestPath:@"profile/friendship_requests" parameters:@{@"id":idx} method:PMAPIClientHTTPMethodPOST mapResponseToClass:[PMFriendshipRequestResponse class]];
}

- (RACSignal *)getFriendshipRequests:(BOOL)outgoing form:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    if (outgoing) {
        params = [params mtl_dictionaryByAddingEntriesFromDictionary: @{@"outgoing":@YES}];
    }
    params = [params dictionaryByRemovingNullValues];

    return [self.apiClient requestPath:@"profile/friendship_requests" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFriendshipRequestsResponse class]];
}

- (RACSignal *)acceptFriendshipRequest:(NSNumber *)idx
{
    return [self.apiClient requestPath:@"profile/friendship_requests/accept" parameters:@{@"id":idx} method:PMAPIClientHTTPMethodPOST mapResponseToClass:nil];
}

- (RACSignal *)rejectFriendshipRequest:(NSNumber *)idx
{
    return [self.apiClient requestPath:@"profile/friendship_requests/reject" parameters:@{@"id":idx} method:PMAPIClientHTTPMethodPOST mapResponseToClass:nil];
}

- (RACSignal *)destroyFriendshipRequest:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"profile/friendship_requests/%@", idx];
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodDELETE mapResponseToClass:nil];
}

- (RACSignal *)getFriends:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"profile/friends" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFriendsResponse class]];
}

- (RACSignal *)getFriendsOfDreamer:(NSNumber *)index filterForm:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/friends", index];
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:requestPath
                            parameters:params
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMFriendsResponse class]];
}

- (RACSignal *)destroyProfileFriendRequest:(NSNumber *)idx
{
    NSString *requestPath = [NSString stringWithFormat:@"profile/friends/%@", idx];
    return [self.apiClient requestPath:requestPath parameters:nil method:PMAPIClientHTTPMethodDELETE mapResponseToClass:nil];
}

- (RACSignal *)getFollowers:(NSNumber *)idx filterForm:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/followers", idx];
    
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:requestPath parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFollowersResponse class]];
}

- (RACSignal *)getFollowees:(PMDreamerFilterForm *)form page:(PMPage *)page
{
    if ([form.ageFrom isEqual:@""])
        form.ageFrom = nil;
    if ([form.ageTo isEqual:@""])
        form.ageTo = nil;
    
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    
    return [self.apiClient requestPath:@"profile/followees" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMFolloweesResponse class]];
}

@end