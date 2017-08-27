//
//  PMMultiAuthDelegate.h
//  MyDreams
//
//  Created by user on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMSocialNetworkAuth.h"

extern NSString * const PMSocialAuthFactoryFacebook;
extern NSString * const PMSocialAuthFactoryVK;
extern NSString * const PMSocialAuthFactoryInstagram;
extern NSString * const PMSocialAuthFactoryTwitter;

@interface PMSocialAuthFactory: NSObject
- (void)registerSocialNetwork:(NSString *)socialNetwork withClass:(id <PMSocialNetworkAuth>)socialNetworkAuth;
- (id<PMSocialNetworkAuth>)socialNetwork:(NSString *)socialNetwork;
@end
