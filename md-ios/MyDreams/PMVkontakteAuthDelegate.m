//
//  PMVkontakteOutDelegate.m
//  MyDreams
//
//  Created by user on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMVkontakteAuthDelegate.h"
#import "VKSdk.h"
#import "PMSocialNetworkCredentials.h"

@interface PMVkontakteAuthDelegate () <VKSdkUIDelegate, VKSdkDelegate>
@property (weak, nonatomic) UIViewController *controller;
@property (strong, nonatomic) RACSubject *resultSubject;
@property (strong, nonatomic) NSString *appId;
@end

@implementation PMVkontakteAuthDelegate

- (instancetype)initWithAppId:(NSString *)appId
{
    self = [super init];
    if (self) {
        self.appId = appId;
        
        VKSdk *sdkInstance = [VKSdk initializeWithAppId:self.appId];
        [sdkInstance registerDelegate:self];
        [sdkInstance setUiDelegate:self];
    }
    
    return self;
}

- (RACSubject *)authWithController:(UIViewController *)controller
{
    self.resultSubject = [RACSubject subject];
    self.controller = controller;
    
    NSArray *scope = @[VK_PER_EMAIL];
    
    [VKSdk wakeUpSession:scope completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            
            PMSocialNetworkCredentials *credentials = [[PMSocialNetworkCredentials alloc] init];
            credentials.token = [VKSdk accessToken].accessToken;
            credentials.email = [VKSdk accessToken].email;
            
            [self.resultSubject sendNext:credentials];
            [self.resultSubject sendCompleted];
            
        } else if (error) {
            [self.resultSubject sendError:error];
        } else {
            [VKSdk authorize:scope];
        }
    }];

    return  self.resultSubject;
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    if (result.error) {
        [self.resultSubject sendError:result.error];
    }
    else if ((!result.error) && (result.state == VKAuthorizationPending)) {
        
        PMSocialNetworkCredentials *credentials = [[PMSocialNetworkCredentials alloc] init];
        credentials.token = result.token.accessToken;
        credentials.email = result.token.email;
        
        [self.resultSubject sendNext:credentials];
        [self.resultSubject sendCompleted];
    }
}

- (void)vkSdkUserAuthorizationFailed
{
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self.controller presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    
}

@end
