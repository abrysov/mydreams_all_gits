//
//  PMOAuth2APIClient.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMOAuth2APIClientImpl.h"
#import <AFNetworking/AFNetworking.h>

NSString *const kPMOAuth2APIClientPasswordCredentialsGrantType = @"password";
NSString *const kPMOAuth2APIClientCodeGrantType = @"authorization_code";
NSString *const kPMOAuth2APIClientRefreshGrantType = @"refresh_token";

NSString * const PMOAuth2APIClientErrorDomain = @"com.perpetuumlab.network.oauth2.error";

@interface PMOAuth2APIClientImpl ()
@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic) NSString *serviceProviderIdentifier;
@end

@implementation PMOAuth2APIClientImpl
@synthesize useHTTPBasicAuthentication = _useHTTPBasicAuthentication;

- (instancetype)initWithBaseURL:(NSURL *)baseUrl
                  configuration:(NSURLSessionConfiguration *)configuration
                       clientID:(NSString *)clientID
                         secret:(NSString *)secret
{
    self = [super initWithBaseURL:baseUrl configuration:configuration];
    if (self) {
        self.serviceProviderIdentifier = [baseUrl host];
        self.clientID = clientID;
        self.clientSecret = secret;
        self.useHTTPBasicAuthentication = YES;
    }
    
    return self;
}

- (void)setUseHTTPBasicAuthentication:(BOOL)useHTTPBasicAuthentication
{
    self->_useHTTPBasicAuthentication = useHTTPBasicAuthentication;
    
    if (self->_useHTTPBasicAuthentication) {
        [self.sessionManager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.clientID password:self.clientSecret];
    } else {
        [self.sessionManager.requestSerializer clearAuthorizationHeader];
    }
}

- (void)logout
{
    [self.sessionManager.requestSerializer clearAuthorizationHeader];
}

- (void)authenticateUsingOAuthWithCredential:(PMOAuthCredential *)credential
{
    if ([[credential.tokenType lowercaseString] compare:@"bearer" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
        [self.sessionManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", credential.accessToken] forHTTPHeaderField:@"Authorization"];
    }
}

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                     username:(NSString *)username
                                     password:(NSString *)password
                                        scope:(NSString *)scope
{
    NSMutableDictionary *parameters = [@{ @"grant_type": kPMOAuth2APIClientPasswordCredentialsGrantType,
                                          @"username": username,
                                          @"password": password} mutableCopy];
    
    if (scope) {
        parameters[@"scope"] = scope;
    }

    return [self authenticateUsingOAuthWithPath:path params:parameters];
}

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path refreshToken:(NSString *)refreshToken
{
    NSDictionary *parameters = @{ @"grant_type": kPMOAuth2APIClientRefreshGrantType,
                                  @"refresh_token": refreshToken};
    
    return [self authenticateUsingOAuthWithPath:path params:parameters];
}

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path
                                         code:(NSString *)code
                                  redirectURI:(NSString *)uri
{
    
    NSDictionary *parameters = @{ @"grant_type": kPMOAuth2APIClientCodeGrantType,
                                  @"code": code,
                                  @"redirect_uri": uri};
    
    return [self authenticateUsingOAuthWithPath:path params:parameters];
}

#pragma mark - private

- (RACSignal *)authenticateUsingOAuthWithPath:(NSString *)path params:(NSDictionary *)params
{
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if (!self.useHTTPBasicAuthentication) {
        mutableParameters[@"client_id"] = self.clientID;
        mutableParameters[@"client_secret"] = self.clientSecret;
    }
    else {
        
    }
    
    params = [NSDictionary dictionaryWithDictionary:mutableParameters];
    
    return [[self requestPath:path parameters:params method:PMAPIClientHTTPMethodPOST]
        flattenMap:^RACStream *(RACTuple *x) {
            id response = x.first;
            
            if (!response) {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: NSLocalizedString(@"Internal server error.", nil)};
                NSError *error = [NSError errorWithDomain:PMOAuth2APIClientErrorDomain code:-1 userInfo:userInfo];
                return [RACSignal error:error];
            }
            
            if ([response valueForKey:@"error"]) {
                return [RACSignal error:[self mapErrorFromRFC6749Response:response]];
            }
            
            NSString *refreshToken = [response valueForKey:@"refresh_token"];
            if ([refreshToken isEqual:[NSNull null]]) {
                refreshToken = nil;
            }
            
            NSDate *expireDate = [NSDate distantFuture];
            id expiresIn = [response valueForKey:@"expires_in"];
            if (expiresIn && [expiresIn isKindOfClass:[NSNumber class]]) {
                expireDate = [NSDate dateWithTimeIntervalSinceNow:[expiresIn doubleValue]];
            }
            
            PMOAuthCredential *credential = [[PMOAuthCredential alloc] initWithOAuthToken:[response valueForKey:@"access_token"]
                                                                                tokenType:[response valueForKey:@"token_type"]
                                                                             refreshToken:[response valueForKey:@"refresh_token"]
                                                                               expiration:expireDate];
            
            return [RACSignal return:credential];
        }];
}

- (NSError *)mapErrorFromRFC6749Response:(id)response
{
    NSString *description = nil;
    if ([response valueForKey:@"error_description"]) {
        description = response[@"error_description"];
    }
    else {
        if ([[response valueForKey:@"error"] isEqualToString:@"invalid_request"]) {
            description = NSLocalizedString(@"The request is missing a required parameter, includes an unsupported parameter value (other than grant type), repeats a parameter, includes multiple credentials, utilizes more than one mechanism for authenticating the client, or is otherwise malformed.", nil);
        } else if ([[response valueForKey:@"error"] isEqualToString:@"invalid_client"]) {
            description = NSLocalizedString(@"Client authentication failed (e.g., unknown client, no client authentication included, or unsupported authentication method).  The authorization server MAY return an HTTP 401 (Unauthorized) status code to indicate which HTTP authentication schemes are supported.  If the client attempted to authenticate via the \"Authorization\" request header field, the authorization server MUST respond with an HTTP 401 (Unauthorized) status code and include the \"WWW-Authenticate\" response header field matching the authentication scheme used by the client.", nil);
        } else if ([[response valueForKey:@"error"] isEqualToString:@"invalid_grant"]) {
            description = NSLocalizedString(@"The provided authorization grant (e.g., authorization code, resource owner credentials) or refresh token is invalid, expired, revoked, does not match the redirection URI used in the authorization request, or was issued to another client.", nil);
        } else if ([[response valueForKey:@"error"] isEqualToString:@"unauthorized_client"]) {
            description = NSLocalizedString(@"The authenticated client is not authorized to use this authorization grant type.", nil);
        } else if ([[response valueForKey:@"error"] isEqualToString:@"unsupported_grant_type"]) {
            description = NSLocalizedString(@"The authorization grant type is not supported by the authorization server.", nil);
        } else {
            description = NSLocalizedString(@"Internal server error.", nil);
        }
    }
    
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey: description};
    return [NSError errorWithDomain:PMOAuth2APIClientErrorDomain code:-1 userInfo:userInfo];
}

@end
