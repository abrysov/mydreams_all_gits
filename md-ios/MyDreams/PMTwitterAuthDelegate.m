//
//  PMTwitterAuthDelegate.m
//  MyDreams
//
//  Created by user on 31.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTwitterAuthDelegate.h"
#import <TwitterKit/Twitter.h>
#import "PMSocialNetworkCredentials.h"

@implementation PMTwitterAuthDelegate

- (RACSubject *)authWithController:(UIViewController *)controller
{
    RACSubject *resultSubject =  [RACSubject subject];
    
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * _Nullable session, NSError * _Nullable error) {
        if (error) {
            [resultSubject sendError:error];
        } else {
            PMSocialNetworkCredentials *credentials = [[PMSocialNetworkCredentials alloc] init];
            credentials.token = session.authToken;
            
            [resultSubject sendNext:credentials];
            [resultSubject sendCompleted];
        }
    }];
    
    return resultSubject;
}

@end
