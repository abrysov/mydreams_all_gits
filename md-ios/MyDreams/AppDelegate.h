//
//  AppDelegate.h
//  MyDreams
//
//  Created by Иван Ушаков on 12.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PMAppearanceConfig;
@protocol PMAuthService;
@protocol PMApplicationRouter;
@protocol PMSocketClient;
@protocol PMUserProvider;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PMAppearanceConfig *appearanceConfig;
@property (strong, nonatomic) id<PMAuthService> authService;
@property (strong, nonatomic) id<PMApplicationRouter> router;
@property (strong, nonatomic) id<PMSocketClient> socketClient;
@property (strong, nonatomic) id<PMUserProvider> userProvider;
@property (strong, nonatomic) UIWindow *overlayWindow;
@end

