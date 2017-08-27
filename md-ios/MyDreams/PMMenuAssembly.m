//
//  PMMenuAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 22.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMenuAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMMenuLogic.h"
#import "PMMenuVC.h"

#import "PMFastLinksLogic.h"
#import "PMFastLinksContainerController.h"

#import "PMSearchLogic.h"
#import "PMSearchVC.h"

@interface PMMenuAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMMenuAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMMenuLogic *)menuLogic
{
    return [TyphoonDefinition withClass:[PMMenuLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(userProvider)];
        [definition injectProperty:@selector(imageDownloader)];
        [definition injectProperty:@selector(profileApiClient)];
        [definition injectProperty:@selector(router)];
    }];
}

- (PMMenuVC *)menuVC
{
    return [TyphoonDefinition withClass:[PMMenuVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.menuLogic];
    }];
}

- (PMFastLinksLogic *)fastLinksLogic
{
    return [TyphoonDefinition withClass:[PMFastLinksLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(router)];
    }];
}

- (PMFastLinksContainerController *)fastLinksContainerController
{
    return [TyphoonDefinition withClass:[PMFastLinksContainerController class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.fastLinksLogic];
    }];
}

- (PMSearchLogic *)searchLogic
{
    return [TyphoonDefinition withClass:[PMSearchLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamApiClient)];
        [definition injectProperty:@selector(dreamerApiClient)];
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(dreamMapper)];
        [definition injectProperty:@selector(dreamerMapper)];
        [definition injectProperty:@selector(postMapper)];
    }];
}

- (PMSearchVC *)searchVC
{
    return [TyphoonDefinition withClass:[PMSearchVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.searchLogic];
    }];
}
@end
