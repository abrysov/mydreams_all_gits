//
//  PMOAuthCredential.m
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMOAuthCredential.h"

@interface PMOAuthCredential ()
@property (copy, nonatomic, readwrite) NSString *accessToken;
@property (copy, nonatomic, readwrite) NSString *tokenType;
@property (copy, nonatomic, readwrite) NSString *refreshToken;
@property (copy, nonatomic, readwrite) NSDate *expirationDate;
@end


@implementation PMOAuthCredential

- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type
{
    return [[self.class alloc] initWithOAuthToken:token tokenType:type refreshToken:nil expiration:nil];
}

- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type expiration:(NSDate *)expiration
{
    return [[self.class alloc] initWithOAuthToken:token tokenType:type refreshToken:nil expiration:expiration];
}

- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type refreshToken:(NSString *)refreshToken expiration:(NSDate *)expiration
{
    self = [super init];
    
    if (self) {
        self.accessToken = token;
        self.tokenType = type;
        self.refreshToken = refreshToken;
        self.expirationDate = expiration;
    }
    
    return self;
}

- (BOOL)isExpired
{
    return [self.expirationDate compare:[NSDate date]] == NSOrderedAscending;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ accessToken:\"%@\" tokenType:\"%@\" refreshToken:\"%@\" expiration:\"%@\">", [self class], self.accessToken, self.tokenType, self.refreshToken, self.expirationDate];
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.accessToken = [decoder decodeObjectForKey:NSStringFromSelector(@selector(accessToken))];
        self.tokenType = [decoder decodeObjectForKey:NSStringFromSelector(@selector(tokenType))];
        self.refreshToken = [decoder decodeObjectForKey:NSStringFromSelector(@selector(refreshToken))];
        self.expirationDate = [decoder decodeObjectForKey:NSStringFromSelector(@selector(expirationDate))];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessToken forKey:NSStringFromSelector(@selector(accessToken))];
    [encoder encodeObject:self.tokenType forKey:NSStringFromSelector(@selector(tokenType))];
    [encoder encodeObject:self.refreshToken forKey:NSStringFromSelector(@selector(refreshToken))];
    [encoder encodeObject:self.expirationDate forKey:NSStringFromSelector(@selector(expirationDate))];
}

@end
