//
//  PMVkontakteOutDelegate.h
//  MyDreams
//
//  Created by user on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSocialNetworkAuth.h"

@interface PMVkontakteAuthDelegate : NSObject <PMSocialNetworkAuth>
- (instancetype)initWithAppId:(NSString *)appId;
@end
