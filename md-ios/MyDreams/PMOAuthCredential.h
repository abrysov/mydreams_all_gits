//
//  PMOAuthCredential.h
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMOAuthCredential : NSObject <NSCoding>

@property (copy, nonatomic, readonly) NSString *accessToken;
@property (copy, nonatomic, readonly) NSString *tokenType;
@property (copy, nonatomic, readonly) NSString *refreshToken;
@property (copy, nonatomic, readonly) NSDate *expirationDate;
@property (assign, nonatomic, readonly) BOOL isExpired;

- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type;
- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type expiration:(NSDate *)expiration;
- (id)initWithOAuthToken:(NSString *)token tokenType:(NSString *)type refreshToken:(NSString *)refreshToken expiration:(NSDate *)expiration;

@end
