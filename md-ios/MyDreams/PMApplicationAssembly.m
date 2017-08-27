//
//  NNApplicationAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "PMApplicationAssembly.h"
#import "AppDelegate.h"
#import "PMAppearanceConfig.h"
#import "PMApplicationRouterImpl.h"
#import "PMBaseVC.h"
#import "PMBaseLogic.h"

@implementation PMApplicationAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (id)window
{
    return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition) {
        [definition performAfterInjections:@selector(makeKeyAndVisible)];
        definition.scope = TyphoonScopeSingleton;
    }];
}

- (id)applicationRouter
{
    return [TyphoonDefinition withClass:[PMApplicationRouterImpl class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(window) with:self.window];
        definition.scope = TyphoonScopeLazySingleton;
    }];
}

- (id)appDelegate
{
    return [TyphoonDefinition withClass:[AppDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(window) with:self.window];
        [definition injectProperty:@selector(appearanceConfig)];
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(router)];
        [definition injectProperty:@selector(socketClient)];
        [definition injectProperty:@selector(userProvider)];
		[definition injectProperty:@selector(overlayWindow) with:self.overlayWindow];
    }];
}

- (id)appearanceConfig
{
    return [TyphoonDefinition withClass:[PMAppearanceConfig class]];
}

- (id)baseVC
{
    return [TyphoonDefinition withClass:[PMBaseVC class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(alertManager)];
    }];
}

- (id)baseLogic
{
    return [TyphoonDefinition withClass:[PMBaseLogic class]];
}

- (id)overlayWindow
{
	return [TyphoonDefinition withClass:[UIWindow class] configuration:^(TyphoonDefinition *definition) {
		definition.scope = TyphoonScopeWeakSingleton;
		[definition injectProperty:@selector(windowLevel) with:@(UIWindowLevelAlert + 1)];
		[definition injectProperty:@selector(backgroundColor) with:[UIColor clearColor]];
	}];
}

@end
