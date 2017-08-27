//
//  PMPhotosAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 12.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotosAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMListPhotosLogic.h"
#import "PMListPhotosVC.h"

@interface PMPhotosAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMPhotosAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMListPhotosLogic *)listPhotosLogic
{
    return [TyphoonDefinition withClass:[PMListPhotosLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(photoMapper)];
        [definition injectProperty:@selector(profileApiClient)];
    }];
}

- (PMListPhotosVC *)listPhotosVC
{
    return [TyphoonDefinition withClass:[PMListPhotosVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.listPhotosLogic];
        [definition injectProperty:@selector(loadingView)];
    }];
}

@end
