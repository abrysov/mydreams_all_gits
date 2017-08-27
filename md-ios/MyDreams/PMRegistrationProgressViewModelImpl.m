//
//  PMRegistrationProgressViewModelImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationProgressViewModelImpl.h"

@interface PMRegistrationProgressViewModelImpl ()
@property (assign, nonatomic) CGFloat progress;
@end

@implementation PMRegistrationProgressViewModelImpl

- (instancetype)initWithProgress:(CGFloat)progress;
{
    self = [super init];
    if (self) {
        self.progress = progress;
    }
    return self;
}

@end
