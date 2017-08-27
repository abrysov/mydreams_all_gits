//
//  PMEditDreamViewModelImpl.m
//  MyDreams
//
//  Created by user on 25.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditDreamViewModelImpl.h"
#import "PMDreamForm.h"

@interface PMEditDreamViewModelImpl ()
@property (nonatomic, strong) NSString *dreamTitle;
@property (nonatomic, strong) NSString *dreamDescription;
@end

@implementation PMEditDreamViewModelImpl

- (instancetype)initWithDreamForm:(PMDreamForm *)form
{
    self = [super init];
    if (self) {
        RAC(self, dreamTitle) = RACObserve(form, title);
        RAC(self, dreamDescription) = RACObserve(form, dreamDescription);
        RAC(self, photo) = RACObserve(form, photo);
    }
    return self;
}

@end
