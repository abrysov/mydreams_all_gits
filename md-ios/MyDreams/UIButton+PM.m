//
//  UIButton+PM.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UIButton+PM.h"
#import "UIImage+PM.h"
#import <objc/runtime.h>

@implementation UIButton (PM)

#pragma mark - properties

- (void)setBackgroundColorForNormalState:(UIColor *)backgroundColorForNormalState
{
    [self setColor:backgroundColorForNormalState forState:UIControlStateNormal];
    objc_setAssociatedObject(self, @selector(backgroundColorForNormalState), backgroundColorForNormalState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backgroundColorForNormalState
{
    return objc_getAssociatedObject(self, @selector(backgroundColorForNormalState));
}

- (void)setBackgroundColorForDisabledState:(UIColor *)backgroundColorForDisabledState
{
    [self setColor:backgroundColorForDisabledState forState:UIControlStateDisabled];
    objc_setAssociatedObject(self, @selector(backgroundColorForDisabledState), backgroundColorForDisabledState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backgroundColorForDisabledState
{
    return objc_getAssociatedObject(self, @selector(backgroundColorForDisabledState));
}

- (void)setBackgroundColorForHighlightedState:(UIColor *)backgroundColorForHighlightedState
{
    [self setColor:backgroundColorForHighlightedState forState:UIControlStateHighlighted];
    objc_setAssociatedObject(self, @selector(backgroundColorForHighlightedState), backgroundColorForHighlightedState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backgroundColorForHighlightedState
{
    return objc_getAssociatedObject(self, @selector(backgroundColorForHighlightedState));
}

- (void)setBackgroundColorForSelectedState:(UIColor *)backgroundColorForSelectedState
{
    [self setColor:backgroundColorForSelectedState forState:UIControlStateSelected];
    objc_setAssociatedObject(self, @selector(backgroundColorForSelectedState), backgroundColorForSelectedState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)backgroundColorForSelectedState
{
    return objc_getAssociatedObject(self, @selector(backgroundColorForSelectedState));
}

#pragma mark - private

- (void)setColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:state];
}

@end
