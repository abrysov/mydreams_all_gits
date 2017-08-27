//
//  PMBorderedButtonWithIcon.m
//  MyDreams
//
//  Created by user on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButtonWithIcon.h"
#import <FrameAccessor/FrameAccessor.h>

@implementation PMBorderedButtonWithIcon

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self setup];
}

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    [self setup];
}

- (void)setup
{
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]}];
    UIEdgeInsets imageEdgeInsets = self.imageEdgeInsets;
    imageEdgeInsets.left = - (self.width - titleSize.width - self.imageView.bounds.size.width);
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
