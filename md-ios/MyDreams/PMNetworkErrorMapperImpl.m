//
//  PMNetworkErrorMapperImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNetworkErrorMapperImpl.h"
#import <AFNetworking/AFNetworking.h>
#import <Mantle/Mantle.h>
#import "PMResponseMeta.h"
#import "PMNetworkError.h"

@implementation PMNetworkErrorMapperImpl

- (NSError *)mapNetworkError:(NSError *)error
{
    NSMutableDictionary *userInfo = @{NSUnderlyingErrorKey: error,
                                      NSLocalizedDescriptionKey:  NSLocalizedString(@"error.internalError", nil)}.mutableCopy;
    NSUInteger errorCode = [error.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] statusCode];
    
    if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorNotConnectedToInternet) {
        userInfo[NSLocalizedDescriptionKey] = error.localizedDescription;
        
        return [NSError errorWithDomain:PMAPIClientErrorDomain
                                   code:errorCode
                               userInfo:userInfo];
    }
    
    
    id json = nil;
    
    NSData *jsonData = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
    if (jsonData) {
        json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *meta = [json valueForKey:@"meta"];
        
        if (meta) {
            PMResponseMeta *responseMeta = [MTLJSONAdapter modelOfClass:[PMResponseMeta class] fromJSONDictionary:meta error:nil];
            
            if (responseMeta) {
                userInfo[PMAPIClientResponseKey] = responseMeta;
                
                if (responseMeta.message) {
                    userInfo[NSLocalizedDescriptionKey] = responseMeta.message;
                }
                else if (responseMeta.status) {
                    userInfo[NSLocalizedDescriptionKey] = responseMeta.status;
                }
                
                if (responseMeta.code) {
                    errorCode = responseMeta.code;
                }
            }
        }
    }
    
    return [NSError errorWithDomain:PMAPIClientErrorDomain
                               code:errorCode
                           userInfo:userInfo];
}

@end
