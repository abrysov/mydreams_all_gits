//
//  PMLoadPageView.m
//  MyDreams
//
//  Created by user on 05.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLoadPageView.h"

@implementation PMLoadPageView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}

@end
