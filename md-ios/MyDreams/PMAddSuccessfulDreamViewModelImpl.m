//
//  PMAddSuccessfulDreamViewModelImpl.m
//  MyDreams
//
//  Created by user on 17.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddSuccessfulDreamViewModelImpl.h"

@interface PMAddSuccessfulDreamViewModelImpl()
@property (nonatomic, strong) UIImage *photo;
@end

@implementation PMAddSuccessfulDreamViewModelImpl

- (instancetype)initWithDreamForm:(PMDreamForm *)form
{
    self = [super init];
    if (self) {
        RAC(self, photo) = RACObserve(form, photo);
    }
    return self;
}

@end
