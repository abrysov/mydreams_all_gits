//
//  PMButtonWithRightIcon.m
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMButtonWithRightIcon.h"

@implementation PMButtonWithRightIcon

- (void)setIsInverted:(BOOL)isInverted
{
    if (self->_isInverted == _isInverted) {
        self->_isInverted = isInverted;
        self.imageView.transform = (isInverted) ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformMakeRotation(0);
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left + 5.0f;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.titleLabel.font.pointSize]}];
    self.bounds = CGRectMake(0, 0, titleSize.width + self.imageView.bounds.size.width, titleSize.height);
}

@end
