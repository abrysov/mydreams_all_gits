//
//  PMEditPostViewModelImpl.m
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditPostViewModelImpl.h"
#import "PMPostForm.h"

@interface PMEditPostViewModelImpl ()
@property (nonatomic, strong) NSString *postDescription;
@end

@implementation PMEditPostViewModelImpl

- (instancetype)initWithPostForm:(PMPostForm *)form
{
    self = [super init];
    if (self) {
        RAC(self, postDescription) = RACObserve(form, content);
    }
    return self;
}

@end
