//
//  PMFilledButton.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFilledButton.h"
#import "UIColor+MyDreams.h"
#import "UIFont+MyDreams.h"
#import <FrameAccessor/FrameAccessor.h>
#import "UIImage+PM.h"

@implementation PMFilledButton

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

- (void)setSelectedColor:(UIColor *)selectedFillColor
{
    self->_selectedColor = selectedFillColor;
    [self updateImages];
}

- (void)setNormalColor:(UIColor *)normalFillColor
{
    self->_normalColor = normalFillColor;
    [self updateImages];
}

#pragma mark - private

- (void)setup
{
    self.adjustsImageWhenHighlighted = NO;
    self.adjustsImageWhenDisabled = NO;
    self.normalColor = [UIColor filledButtonFillColorNormal];
    self.selectedColor = [UIColor filledButtonFillColorHighlighted];
}

- (void)updateImages
{
    UIImage *normalBackgroundImage = [UIImage filledRoundedRectImageWithColor:self.normalColor
                                                                         size:self.bounds.size
                                                                 cornerRadius:self.height / 2];
    
    UIImage *highlightedBackgroundImage = [UIImage filledRoundedRectImageWithColor:self.selectedColor
                                                                              size:self.bounds.size
                                                                      cornerRadius:self.height / 2];
    
    [self setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightedBackgroundImage forState:UIControlStateHighlighted];
}

@end
