//
//  PMGradientBorderedButton.m
//  MyDreams
//
//  Created by Alexey Yakunin on 13/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMGradientBorderedButton.h"
#import "UIColor+MyDreams.h"
#import <FrameAccessor/FrameAccessor.h>
#import "UIImage+PM.h"

@implementation PMGradientBorderedButton

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

#pragma mark - properties

- (void)setKern:(CGFloat )kern
{
    self->_kern = kern;
    [self updateKern];
}


- (void)setNormalBorderColor:(UIColor *)normalBorderColor
{
    self->_normalBorderColor = normalBorderColor;
    [self updateImages];
}

- (void)setSelectedBorderColor:(UIColor *)selectedBorderColor
{
    self->_selectedBorderColor = selectedBorderColor;
    [self updateImages];
}

- (void)setNormalStartColor:(UIColor *)normalStartColor
{
    self->_normalStartColor = normalStartColor;
    [self updateImages];
}

- (void)setSelectedStartColor:(UIColor *)selectedStartColor
{
    self->_selectedStartColor = selectedStartColor;
    [self updateImages];
}

- (void)setNormalEndColor:(UIColor *)normalEndColor
{
    self->_normalEndColor = normalEndColor;
    [self updateImages];
}

- (void)setSelectedEndColor:(UIColor *)selectedEndColor
{
    self->_selectedEndColor = selectedEndColor;
    [self updateImages];
}

#pragma mark - private

- (void)setup
{
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;

    self->_normalBorderColor = [UIColor borderedButtonStrokeColor];
    self->_selectedBorderColor = [UIColor borderedButtonStrokeColor];
    self->_normalStartColor = [UIColor borderedButtonGradientBeginColorNormal];
    self->_normalEndColor = [UIColor borderedButtonGradientEndColorNormal];
    self->_selectedStartColor = [UIColor borderedButtonGradientBeginColorHighlighted];
    self->_selectedEndColor = [UIColor borderedButtonGradientEndColorHighlighted];

    [self updateImages];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (title) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName: @(self.kern),
                                                                                                   NSFontAttributeName: self.titleLabel.font,
                                                                                                   NSForegroundColorAttributeName: [self titleColorForState:state]}];
        [self setAttributedTitle:string forState:state];
    }
    else {
        [super setTitle:title forState:state];
    }
}

- (NSString *)titleForState:(UIControlState)state
{
    return [[self attributedTitleForState:state] string];
}

- (void)updateImages
{
    UIImage *normalBackgroundImage = [self normalBackgroundImage];
    UIImage *highlightedBackgroundImage = [self highlightedBackgroundImage];

    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (void)updateKern
{
    [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
}

- (UIImage *)normalBackgroundImage
{
    return [UIImage gradientStrokedRectImagetWithStrokeColor:self.normalBorderColor startColor:self.normalStartColor endColor:self.normalEndColor size:self.bounds.size lineWidth:1.0f cornerRadius:self.height / 2];
}

- (UIImage *)highlightedBackgroundImage
{
    return [UIImage gradientStrokedRectImagetWithStrokeColor:self.selectedBorderColor startColor:self.selectedStartColor endColor:self.selectedEndColor size:self.bounds.size lineWidth:1.0f cornerRadius:self.height / 2];
}

@end
