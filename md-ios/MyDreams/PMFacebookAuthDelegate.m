//
//  PMFacebookAuthDelegate.m
//  MyDreams
//
//  Created by user on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFacebookAuthDelegate.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PMSocialNetworkCredentials.h"

@implementation PMFacebookAuthDelegate

- (RACSubject *)authWithController:(UIViewController *)controller
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    RACSubject *resultSubject =  [RACSubject subject];
    [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:controller
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (!result.isCancelled) {
                                    if (error) {
                                        [resultSubject sendError:error];
                                    } else {
                                        PMSocialNetworkCredentials *credentials = [[PMSocialNetworkCredentials alloc] init];
                                        credentials.token = result.token.tokenString;
                                        [resultSubject sendNext:credentials];
                                    }
                                }
                            }];
    [resultSubject sendCompleted];
    return resultSubject;
}

@end
