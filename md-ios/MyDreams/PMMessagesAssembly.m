//
//  PMMessagesAssembly.m
//  MyDreams
//
//  Created by Alexey Yakunin on 29/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMessagesAssembly.h"
#import "PMApplicationAssembly.h"

#import "PMListConversationsLogic.h"
#import "PMListConversationsVC.h"

@interface PMMessagesAssembly ()
@property (strong, readonly, nonatomic) PMApplicationAssembly *applicationAssembly;
@end

@implementation PMMessagesAssembly

- (PMListConversationsLogic *)listConversationsLogic
{
	return [TyphoonDefinition withClass:[PMListConversationsLogic class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseLogic;
	}];
}

- (PMListConversationsVC *)listConversationsVC
{
	return [TyphoonDefinition withClass:[PMListConversationsVC class] configuration:^(TyphoonDefinition *definition) {
		definition.parent = self.applicationAssembly.baseVC;
		[definition injectProperty:@selector(logic) with:self.listConversationsLogic];
	}];
}

@end
