//
//  PMGradientView.m
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMGradientView.h"

@interface PMGradientView ()
@property (strong, nonatomic, readonly) CAGradientLayer *layer;
@end

@implementation PMGradientView
@dynamic layer;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self->_startColor = [UIColor whiteColor];
    self->_endColor = [UIColor blackColor];
    [self updateLayerColors];
    self.layer.startPoint = CGPointMake(0.5f, 0.0f);
    self.layer.endPoint = CGPointMake(0.5f, 1.0f);
}

#pragma mark - properies

- (void)setStartColor:(UIColor *)startColor
{
    self->_startColor = startColor;
    [self updateLayerColors];
}

- (void)setEndColor:(UIColor *)endColor
{
    self->_endColor = endColor;
    [self updateLayerColors];
}

- (void)setStartPoint:(CGPoint)startPoint
{
    self.layer.startPoint = startPoint;
}

- (CGPoint)startPoint
{
    return self.layer.startPoint;
}

- (void)setEndPoint:(CGPoint)endPoint
{
    self.layer.endPoint = endPoint;
}

- (CGPoint)endPoint
{
    return self.layer.endPoint;
}

#pragma mark - private

- (void)updateLayerColors
{
    self.layer.colors = @[(id)self.startColor.CGColor, (id)self.endColor.CGColor];
}

+ (Class)layerClass
{
    return CAGradientLayer.self;
}

@end
