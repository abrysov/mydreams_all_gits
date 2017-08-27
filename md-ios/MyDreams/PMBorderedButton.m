//
//  PMButton.m
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButton.h"
#import "UIImage+PM.h"
#import <FrameAccessor/FrameAccessor.h>
#import "UIColor+MyDreams.h"

@implementation PMBorderedButton

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

- (void)setKern:(CGFloat )kern
{
    self->_kern = kern;
    [self updateKern];
}

- (void)setSelectedFillColor:(UIColor *)selectedFillColor
{
    self->_selectedFillColor = selectedFillColor;
    [self updateImages];
}

- (void)setNormalFillColor:(UIColor *)normalFillColor
{
    self->_normalFillColor = normalFillColor;
    [self updateImages];
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

#pragma mark - private

- (void)setup
{
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
        
    self.normalFillColor = [UIColor clearColor];
    self.normalBorderColor = [UIColor borderedButtonStrokeColor];
    self.selectedFillColor = [UIColor borderedButtonFillColor];
    self.selectedBorderColor = [UIColor borderedButtonStrokeColor];
    
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
    UIImage *normalBackgroundImage = [UIImage strokedRoundedRectImageWithColor:self.normalBorderColor
                                                                          fill:self.normalFillColor
                                                                          size:self.bounds.size
                                                                     lineWidth:1.0f
                                                                  cornerRadius:self.height / 2];
    
    UIImage *highlightedBackgroundImage = [UIImage strokedRoundedRectImageWithColor:self.selectedBorderColor
                                                                               fill:self.selectedFillColor
                                                                               size:self.bounds.size
                                                                          lineWidth:1.0f
                                                                       cornerRadius:self.height / 2];
    
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

- (void)updateKern
{
    [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
}

@end
