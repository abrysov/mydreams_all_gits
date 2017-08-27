//
//  PMStorageServiceImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMStorageServiceImpl.h"

@implementation PMStorageServiceImpl
@synthesize storage;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureMigrations];
        self.storage = [RLMRealm defaultRealm];
    }
    return self;
}

- (void)configureMigrations
{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = 1;
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

@end
