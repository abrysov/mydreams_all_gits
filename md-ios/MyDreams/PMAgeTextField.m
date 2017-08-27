//
//  PMAgeTextField.m
//  MyDreams
//
//  Created by user on 04.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAgeTextField.h"
#import "UIColor+MyDreams.h"
#import "UIFont+MyDreams.h"

@implementation PMAgeTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldDreambookColor]}];
}

@end
