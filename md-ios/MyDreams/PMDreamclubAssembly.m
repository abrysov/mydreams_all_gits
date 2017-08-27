//
//  PMDreamclubAssembly.m
//  MyDreams
//
//  Created by user on 08.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamclubAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMDreamClubLogic.h"
#import "PMDreamClubVC.h"

#import "PMDreamClubHeaderLogic.h"
#import "PMDreamClubHeaderVC.h"

@interface PMDreamclubAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMDreamclubAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMDreamClubLogic *)dreamClubLogic
{
    return [TyphoonDefinition withClass:[PMDreamClubLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamclubWrapperApiClient)];
        [definition injectProperty:@selector(postMapper)];
    }];
}

- (PMDreamClubVC *)dreamClubVC
{
    return [TyphoonDefinition withClass:[PMDreamClubVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.dreamClubLogic];
    }];
}

- (PMDreamClubHeaderLogic *)dreamClubHeaderLogic
{
    return [TyphoonDefinition withClass:[PMDreamClubHeaderLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(dreamclubWrapperApiClient)];
        [definition injectProperty:@selector(imageDownloader)];
    }];
}

- (PMDreamClubHeaderVC *)dreamClubHeaderVC
{
    return [TyphoonDefinition withClass:[PMDreamClubHeaderVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.dreamClubHeaderLogic];
    }];
}


@end
