//
//  PMAuthService.h
//  MyDreams
//
//  Created by Иван Ушаков on 17.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSocialNetworkCredentials.h"
@class PMUserForm;

typedef NS_ENUM(NSUInteger, PMAuthServiceSocialNetwork) {
    PMAuthServiceSocialNetworkFacebook,
    PMAuthServiceSocialNetworkTwitter,
    PMAuthServiceSocialNetworkVK,
    PMAuthServiceSocialNetworkInstagram,
};

@protocol PMAuthService <NSObject>
@property (assign, nonatomic, readonly) BOOL isAuthorized;
@property (assign, nonatomic, readonly) BOOL canReauthenticate;

- (RACSignal *)authenticateWithUsername:(NSString *)username password:(NSString *)password;
- (RACSignal *)authenticateWithSocialNetwork:(PMAuthServiceSocialNetwork)socialNetwork credentials:(PMSocialNetworkCredentials *)credentials;
- (RACSignal *)reauthenticate;
- (void)logout;

- (RACSignal *)registerDreamer:(PMUserForm *)form;

- (RACSignal *)remaindPasswordWithEmail:(NSString *)email;
- (RACSignal *)restoreProfile;
- (RACSignal *)userAgreement;
@end
