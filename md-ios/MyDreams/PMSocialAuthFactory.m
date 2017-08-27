//
//  PMMultiAuthDelegate.m
//  MyDreams
//
//  Created by user on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSocialAuthFactory.h"

NSString * const PMSocialAuthFactoryFacebook = @"facebook";
NSString * const PMSocialAuthFactoryVK = @"vk";
NSString * const PMSocialAuthFactoryInstagram = @"instagram";
NSString * const PMSocialAuthFactoryTwitter = @"twitter";

@interface PMSocialAuthFactory ()
@property (strong, nonatomic) NSMutableDictionary *socialNetworks;
@end

@implementation PMSocialAuthFactory

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socialNetworks = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerSocialNetwork:(NSString *)socialNetwork withClass:(id <PMSocialNetworkAuth>)socialNetworkAuth
{
    [self.socialNetworks setValue:socialNetworkAuth forKey:socialNetwork];
}

- (id<PMSocialNetworkAuth>)socialNetwork:(NSString *)socialNetwork
{
    return self.socialNetworks[socialNetwork];
}

@end
