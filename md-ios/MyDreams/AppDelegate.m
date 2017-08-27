//
//  AppDelegate.m
//  MyDreams
//
//  Created by Иван Ушаков on 12.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "AppDelegate.h"
#import "PMAppearanceConfig.h"
#import "PMAuthService.h"
#import "PMApplicationRouter.h"
#import <VK_ios_sdk/VKSdk.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <TwitterKit/TwitterKit.h>
#import "PMSocketClient.h"
#import "PMUserProvider.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self.appearanceConfig apply];
    
    [Fabric with:@[[Crashlytics class], [Twitter class]]];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    if ([self.authService canReauthenticate]) {
        @weakify(self);
        [[self.authService reauthenticate] subscribeNext:^(id x) {
            @strongify(self);
            [self.socketClient openSocketWithToken:self.userProvider.me.token];
        }];
        [self.router openMainVC];
    }
    else {
        [self.router openAuthVC];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                        sourceApplication:sourceApplication
                                                annotation:annotation];
    return YES;
}

@end
