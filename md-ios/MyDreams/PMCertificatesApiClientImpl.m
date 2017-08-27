//
//  PMMarksApiClientImpl.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatesApiClientImpl.h"
#import "PMOAuth2ApiClient.h"
#import "PMCertificatesForm.h"
#import "PMPage.h"
#import "NSDictionary+PM.h"
#import "PMCertificatesResponse.h"

@implementation PMCertificatesApiClientImpl

- (RACSignal *)getCertificates:(PMCertificatesForm *)form page:(PMPage *)page
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:@"profile/certificates" parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMCertificatesResponse class]];
}

- (RACSignal *)getCertificatesWithDreamerIdx:(NSNumber *)dreamerIdx form:(PMCertificatesForm *)form page:(PMPage *)page
{
    NSString *requestPath = [NSString stringWithFormat:@"dreamers/%@/certificates", dreamerIdx];
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    params = [params mtl_dictionaryByAddingEntriesFromDictionary:[MTLJSONAdapter JSONDictionaryFromModel:page error:nil]];
    params = [params dictionaryByRemovingNullValues];
    return [self.apiClient requestPath:requestPath parameters:params method:PMAPIClientHTTPMethodGET mapResponseToClass:[PMCertificatesResponse class]];
}

@end
