//
//  PMBlackTitlePlaceholderTextField.m
//  MyDreams
//
//  Created by user on 16.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBlackTitlePlaceholderTextField.h"
#import "UIColor+MyDreams.h"
#import "UIFont+MyDreams.h"

@implementation PMBlackTitlePlaceholderTextField

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
                                                                 attributes:@{
                                                                    NSForegroundColorAttributeName: [UIColor textFieldPlaceholderTextColor]}];
}
@end
