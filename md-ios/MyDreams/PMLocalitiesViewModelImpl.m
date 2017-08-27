//
//  PMLocalitiesViewModelImpl.m
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalitiesViewModelImpl.h"

@interface PMLocalitiesViewModelImpl ()
@property (nonatomic, strong) NSArray *localities;
@end

@implementation PMLocalitiesViewModelImpl

- (instancetype)initWithLocalities:(NSArray *)localities
{
    self = [super init];
    if (self) {
        self.localities = localities;
    }
    return self;
}

@end

