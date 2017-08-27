//
//  PMSettingsAssembly.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSettingsAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMSettingsLogic.h"
#import "PMSettingsVC.h"
#import "PMChangePasswordVC.h"
#import "PMChangePasswordLogic.h"
#import "PMChangeEmailVC.h"
#import "PMChangeEmailLogic.h"
#import "PMEditProfileVC.h"
#import "PMEditProfileLogic.h"

@interface PMSettingsAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMSettingsAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMSettingsLogic *)settingsLogic
{
    return [TyphoonDefinition withClass:[PMSettingsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(authService)];
        [definition injectProperty:@selector(profileApiClient)];
    }];
}

- (PMSettingsVC *)settingsVC
{
    return [TyphoonDefinition withClass:[PMSettingsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.settingsLogic];
    }];
}

- (PMChangePasswordLogic *)changePasswordLogic
{
    return [TyphoonDefinition withClass:[PMChangePasswordLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(profileApiClient)];
    }];
}

- (PMChangePasswordVC *)changePasswordVC
{
    return [TyphoonDefinition withClass:[PMChangePasswordVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.changePasswordLogic];
    }];
}

- (PMChangeEmailLogic *)changeEmaiLogic
{
    return [TyphoonDefinition withClass:[PMChangeEmailLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(profileApiClient)];
        [definition injectProperty:@selector(emailValidator)];
    }];
}

- (PMChangeEmailVC *)changeEmailVC
{
    return [TyphoonDefinition withClass:[PMChangeEmailVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.changeEmaiLogic];
    }];
}

- (PMEditProfileLogic *)editProfileLogic
{
    return [TyphoonDefinition withClass:[PMEditProfileLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(profileApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMEditProfileVC *)editProfileVC
{
    return [TyphoonDefinition withClass:[PMEditProfileVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.editProfileLogic];
    }];
}

@end
