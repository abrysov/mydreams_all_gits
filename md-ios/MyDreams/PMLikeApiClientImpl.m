//
//  PMApiLikeImpl.m
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLikeApiClientImpl.h"
#import "PMAPIClient.h"
#import "PMLikesResponse.h"
#import "NSDictionary+PM.h"
#import "PMPage.h"

@implementation PMLikeApiClientImpl

- (RACSignal *)createLikeWithIdx:(NSNumber *)idx entityType:(PMEntityType)type
{
    NSString *entityType = [PMEntityTypeConverter entityTypeToString:type];

    NSDictionary *params = @{@"entity_id":idx,
                             @"entity_type":entityType};
    
    return [self.apiClient requestPath:@"likes"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:[PMLikesResponse class]];
}

- (RACSignal *)removeLikeWithIdx:(NSNumber *)idx entityType:(PMEntityType)type
{
    NSString *requestPath = [NSString stringWithFormat:@"likes/%@", idx];
    NSString *entityType = [PMEntityTypeConverter entityTypeToString:type];
    
    NSDictionary *params = @{@"entity_type":entityType};
    
    return [self.apiClient requestPath:requestPath
                            parameters:params
                                method:PMAPIClientHTTPMethodDELETE
                    mapResponseToClass:nil];
}

- (RACSignal *)getDreamersWhoLikedEntityWithIdx:(NSNumber *)idx entityType:(PMEntityType)type page:(PMPage *)page
{
	NSString *requestPath = @"likes";
	NSString *entityType = [PMEntityTypeConverter entityTypeToString:type];
	NSDictionary *params = @{@"entity_id":idx,
							 @"entity_type":entityType};
	params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
	params = [params dictionaryByRemovingNullValues];
	
	return [self.apiClient requestPath:requestPath
							parameters:params
								method:PMAPIClientHTTPMethodGET
					mapResponseToClass:[PMLikesResponse class]];
}

@end
