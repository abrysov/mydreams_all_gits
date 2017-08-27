//
//  PMAuthServiceImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAuthServiceImpl.h"
#import "PMOAuth2APIClient.h"
#import "PMOAuthCredential.h"
#import "PMCredentialStore.h"
#import "PMDataFetcher.h"
#import "PMUserProvider.h"
#import "PMDreamerResponse.h"
#import "PMSocialNetworkCredentials.h"
#import "PMUserAgreementResponse.h"
#import "PMUserForm.h"
#import "PMDreamerResponse.h"
#import "PMProfileApiClient.h"

NSString *const kMyDreamsCredentialStoreIdentifier = @"MyDreams";

@interface PMAuthServiceImpl ()
@property (assign, nonatomic, readwrite) BOOL isAuthorized;
@end

@implementation PMAuthServiceImpl

- (BOOL)canReauthenticate
{
    id credential = [self.credentialStore retrieveCredentialWithIdentifier:kMyDreamsCredentialStoreIdentifier];
    return (credential != nil && [credential isKindOfClass:[PMOAuthCredential class]]);
}

- (void)logout
{
    [self.credentialStore deleteCredentialWithIdentifier:kMyDreamsCredentialStoreIdentifier];
    [self.apiClient logout];
    self.isAuthorized = NO;
    
    [self.dataFetcher stop];
    self.userProvider.me = nil;
    self.userProvider.status = nil;
}

- (RACSignal *)reauthenticate
{
    PMOAuthCredential *credential = (PMOAuthCredential *)[self.credentialStore retrieveCredentialWithIdentifier:kMyDreamsCredentialStoreIdentifier];
    [self.apiClient authenticateUsingOAuthWithCredential:credential];
    self.isAuthorized = YES;
    
    [self.dataFetcher start];
    return [self doAfterAuth:[RACSignal empty]];
}

- (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password
{
    return [self doAfterAuth:[self.apiClient authenticateUsingOAuthWithPath:@"oauth/token" username:username password:password scope:nil]];
}

- (RACSignal *)authenticateWithSocialNetwork:(PMAuthServiceSocialNetwork)socialNetwork credentials:(PMSocialNetworkCredentials *)credentials
{
    NSMutableDictionary *params = [@{@"grant_type": @"assertion",
                                     @"provider": [self socialNetworkToString:socialNetwork],
                                     @"assertion": credentials.token} mutableCopy];
    
    if (credentials.email) {
        [params setObject:credentials.email forKey:@"email"];
    }

    return [self doAfterAuth:[self.apiClient authenticateUsingOAuthWithPath:@"oauth/token" params:params]];
}

- (RACSignal *)remaindPasswordWithEmail:(NSString *)email
{
    NSDictionary *params = @{@"email": email};
    return [self.apiClient requestPath:@"passwords/reset"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:nil];
}

- (RACSignal *)restoreProfile
{
    return [self.apiClient requestPath:@"profile/restore"
                            parameters:nil
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:nil];
}

- (RACSignal *)userAgreement
{
    return [self.apiClient requestPath:@"static/terms"
                            parameters:nil
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMUserAgreementResponse class]];
}

- (RACSignal *)registerDreamer:(PMUserForm *)form
{
    NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:form error:nil];
    return [self.apiClient requestPath:@"dreamers"
                            parameters:params
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:[PMDreamerResponse class]];
}

#pragma mark - private

- (NSString *)socialNetworkToString:(PMAuthServiceSocialNetwork)socialNetwork
{
    switch (socialNetwork) {
        case PMAuthServiceSocialNetworkFacebook:
            return @"facebook";
        case PMAuthServiceSocialNetworkTwitter:
            return @"twitter";
        case PMAuthServiceSocialNetworkVK:
            return @"vkontakte";
        case PMAuthServiceSocialNetworkInstagram:
            return @"instagram";
    }
}

- (RACSignal *)doAfterAuth:(RACSignal *)signal
{
    @weakify(self);
    return [[[[signal doNext:^(PMOAuthCredential *credential) {
            @strongify(self);
            [self.credentialStore storeCredential:credential withIdentifier:kMyDreamsCredentialStoreIdentifier];
            [self.apiClient authenticateUsingOAuthWithCredential:credential];
            self.isAuthorized = YES;
            [self.dataFetcher start];
        }]
        then:^RACSignal *{
            @strongify(self);
            return [self.profileApiClient getMe];
        }]
        doError:^(NSError *error) {
            @strongify(self);
            [self logout];
        }]
        doNext:^(PMDreamerResponse *response) {
            @strongify(self);
            self.userProvider.me = response.dreamer;
        }];
}

@end
