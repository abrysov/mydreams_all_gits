//
//  CommonLabel.m
//  MyDreams
//
//  Created by Игорь on 29.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CommonLabel.h"
#import "Helper.h"

@implementation CommonLabel

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

- (void)initAppearence {
    [self localize];
}

- (void)localize {
    NSString *text = [Helper localizedStringIfIsCode:self.text];
    if (text) {
        [self setText:text];
    }
}

@end
