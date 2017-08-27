//
//  CommonButton.m
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BorderedButton.h"
#import "Helper.h"
#import "LocalizedButton.h"

@implementation BorderedButton

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if (self) {
        [self initAppearence];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initAppearence];
    }
    return self;
}

- (void)localize {
    [super localize];
}

- (void)initAppearence {
    [self localize];
    
    [self showsTouchWhenHighlighted];
    
    [self.layer setShadowOffset:CGSizeMake(1, 1)];
    [self.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.layer setShadowOpacity:0.4];
    [self.layer setShadowRadius:1.8];
    [self.layer setCornerRadius:2];
}

@end
