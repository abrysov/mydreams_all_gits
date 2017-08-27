//
//  PMNewsAssembly.m
//  MyDreams
//
//  Created by Иван Ушаков on 13.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMNewsFeedLogic.h"
#import "PMNewsFeedVC.h"

#import "PMUpdatingLogic.h"
#import "PMUpdatingVC.h"

#import "PMRecommendationsLogic.h"
#import "PMRecommendationsVC.h"

#import "PMCommentsLogic.h"
#import "PMCommentsVC.h"

@interface PMNewsAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMNewsAssembly

- (id)config
{
    return [TyphoonDefinition withConfigName:@"Config.plist"];
}

- (PMNewsFeedLogic *)newsFeedLogic
{
    return [TyphoonDefinition withClass:[PMNewsFeedLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(postMapper)];
    }];
}

- (PMNewsFeedVC *)newsFeedVC
{
    return [TyphoonDefinition withClass:[PMNewsFeedVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.newsFeedLogic];
    }];
}

- (PMUpdatingLogic *)updatingLogic
{
    return [TyphoonDefinition withClass:[PMUpdatingLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
    }];
}

- (PMUpdatingVC *)updatingVC
{
    return [TyphoonDefinition withClass:[PMUpdatingVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.updatingLogic];
    }];
}

- (PMRecommendationsLogic *)recommendationsLogic
{
    return [TyphoonDefinition withClass:[PMRecommendationsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(postMapper)];
    }];
}

- (PMRecommendationsVC *)recommendationsVC
{
    return [TyphoonDefinition withClass:[PMRecommendationsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.recommendationsLogic];
    }];
}

- (PMCommentsLogic *)commentsLogic
{
    return [TyphoonDefinition withClass:[PMCommentsLogic class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseLogic;
        [definition injectProperty:@selector(postApiClient)];
        [definition injectProperty:@selector(postMapper)];
    }];
}

- (PMCommentsVC *)commentsVC
{
    return [TyphoonDefinition withClass:[PMCommentsVC class] configuration:^(TyphoonDefinition *definition) {
        definition.parent = self.applicationAssembly.baseVC;
        [definition injectProperty:@selector(logic) with:self.commentsLogic];
    }];
}

@end
