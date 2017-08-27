//
//  PMBorderedForDreambookButton.m
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookBorderedButton.h"
#import "UIColor+MyDreams.h"

@interface PMDreambookBorderedButton ()
@property (nonatomic, strong) UIColor *mainColor;
@property (nonatomic, strong) UIColor *mainHighlightedColor;
@end


@implementation PMDreambookBorderedButton
@synthesize mainColor = _mainColor, mainHighlightedColor = _mainHighlightedColor;

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

#pragma mark - property

- (void)setMainColor:(UIColor *)mainColor
{
    if (self->_mainColor != mainColor) {
        self->_mainColor = mainColor;
    }
}

- (UIColor *)mainColor
{
    if (_mainColor) {
        return _mainColor;
    }
    else {
        return [UIColor dreambookNormalColor];
    }
}

- (void)setMainHighlightedColor:(UIColor *)mainHighlightedColor
{
    if (self->_mainHighlightedColor != mainHighlightedColor) {
        self->_mainHighlightedColor = mainHighlightedColor;
    }
}

- (UIColor *)mainHighlightedColor
{
    if (_mainHighlightedColor) {
        return _mainHighlightedColor;
    }
    else {
        return [UIColor dreambookNormalHighlightedColor];
    }
}

- (void)setInputState:(PMDreambookBorderedButtonState)inputState
{
    self->_inputState = inputState;
    switch (inputState) {
        case PMDreambookBorderedButtonStateFilled:
            [self applyFilledState];
            break;
        case PMDreambookBorderedButtonStateBordered:
            [self applyBorderedState];
            break;
        case PMDreambookBorderedButtonStateBorderedWithIcon:
            [self applyBorderedWithIconState];
            break;
        case PMDreambookBorderedButtonStateDefault:
        default:
            [self applyDefaultState];
            break;
    }
}

- (void)setDreamerStatus:(PMDreamerStatus)dreamerStatus
{
    self->_dreamerStatus = dreamerStatus;
    switch (dreamerStatus) {
        case PMDreamerStatusVIP:
            self.mainColor = [UIColor dreambookVipColor];
            self.mainHighlightedColor = [UIColor dreambookVipHighlightedColor];
            break;
        case PMDreamerStatusDefault:
        default:
            self.mainColor = [UIColor dreambookNormalColor];
            self.mainHighlightedColor = [UIColor dreambookNormalHighlightedColor];
            break;
    }
}

#pragma mark - private

- (void)applyDefaultState
{
    switch (self.dreamerStatus) {
        case PMDreamerStatusVIP:
            self.normalFillColor = [UIColor clearColor];
            self.normalBorderColor = [UIColor dreambookVipColor];
            self.selectedFillColor = [[UIColor dreambookVipHighlightedColor] colorWithAlphaComponent:0.1f];
            self.selectedBorderColor = [UIColor dreambookVipHighlightedColor];
            [self setImage:nil forState:UIControlStateNormal];
            [self setTitleColor:[UIColor dreambookVipColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor dreambookVipHighlightedColor] forState:UIControlStateHighlighted];
            break;
        case PMDreamerStatusDefault:
        default:
            self.normalFillColor = [UIColor clearColor];
            self.normalBorderColor = [UIColor borderedButtonDreambookColorNormal];
            self.selectedFillColor = [UIColor borderedButtonDreambookColorHighlighted];
            self.selectedBorderColor = [UIColor borderedButtonDreambookColorNormal];
            [self setImage:nil forState:UIControlStateNormal];
            [self setTitleColor:[UIColor borderedButtonDreambookTextColor] forState:UIControlStateNormal];
            [self setTitleColor:[UIColor borderedButtonDreambookTextColor] forState:UIControlStateHighlighted];
            break;
    }
}

- (void)applyBorderedState
{
    self.normalFillColor = [UIColor clearColor];
    self.normalBorderColor = self.mainColor;
    self.selectedFillColor = [self.mainHighlightedColor colorWithAlphaComponent:0.1f];
    self.selectedBorderColor = self.mainHighlightedColor;
    [self setImage:nil forState:UIControlStateNormal];
    
    [self setTitleColor:self.mainColor forState:UIControlStateNormal];
    [self setTitleColor:self.mainHighlightedColor forState:UIControlStateHighlighted];
}

- (void)applyBorderedWithIconState
{
    [self applyBorderedState];
    [self setImage:[[UIImage imageNamed:@"blue_fill_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [self setTintColor:self.mainColor];
}

- (void)applyFilledState
{
    self.normalFillColor = self.mainColor;
    self.normalBorderColor = self.mainColor;
    self.selectedFillColor = self.mainHighlightedColor;
    self.selectedBorderColor = self.mainHighlightedColor;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

@end
