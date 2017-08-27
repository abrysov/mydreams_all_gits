//
//  PMInstagramAuthDelegate.m
//  MyDreams
//
//  Created by user on 31.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMInstagramAuthDelegate.h"
#import <InstagramKit/InstagramKit.h>
#import "PMSocialNetworkCredentials.h"
#import "PMWebVC.h"

@interface PMInstagramAuthDelegate () <WKNavigationDelegate, PMWebVCDelegate>
@property (weak, nonatomic) UIViewController *controller;
@property (strong, nonatomic) PMWebVC *webVC;
@property (strong, nonatomic) RACSubject *resultSubject;
@end

@implementation PMInstagramAuthDelegate 

- (RACSubject *)authWithController:(UIViewController *)controller
{
    self.controller = controller;

    InstagramKitLoginScope scope = InstagramKitLoginScopeRelationships;
    NSURL *authURL = [[InstagramEngine sharedEngine] authorizationURLForScope:scope];
    
    self.webVC = [[PMWebVC alloc] init];
    [self.webVC view];
    
    self.webVC.delegate = self;
    self.webVC.webView.scrollView.bounces = NO;
    self.webVC.webView.navigationDelegate = self;
    self.webVC.title = NSLocalizedString(@"auth.social_auth.instagram", nil);
    [self.webVC.webView loadRequest:[NSURLRequest requestWithURL:authURL]];
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:self.webVC];
    [controller presentViewController:navigationVC animated:YES completion:NULL];
    
    self.resultSubject = [RACSubject subject];
    return self.resultSubject;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:navigationAction.request.URL error:&error]) {
        if (error) {
            [self.resultSubject sendError:error];
        }
        else {
            PMSocialNetworkCredentials *credentials = [[PMSocialNetworkCredentials alloc] init];
            credentials.token = [[InstagramEngine sharedEngine] accessToken];
            
            [self.resultSubject sendNext: credentials];
            [self.resultSubject sendCompleted];
        }
        
        [self.controller dismissViewControllerAnimated:YES completion:NULL];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)closeWebVC:(PMWebVC *)webVC
{
    [self.webVC.webView stopLoading];
    [self.controller dismissViewControllerAnimated:YES completion:NULL];
}

@end
