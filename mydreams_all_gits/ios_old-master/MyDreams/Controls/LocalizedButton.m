//
//  LocalizedButton.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "LocalizedButton.h"
#import "Helper.h"

@implementation LocalizedButton

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
    [LocalizedButton localize:self];
}

+ (void)localize:(UIButton *)button {
    NSString *title = [Helper localizedStringIfIsCode:button.titleLabel.text];
    if (title) {
        [button setTitle:[title uppercaseString] forState:UIControlStateNormal];
    }
}

@end
