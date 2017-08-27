//
//  PMDatePicker.m
//  MyDreams
//
//  Created by user on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDatePicker.h"

@implementation PMDatePicker

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

- (void)setCustomTextColor:(UIColor *)customTextColor
{
    [self setupTextColor:customTextColor];
}

- (void)setup
{
    [self setupTextColor:[UIColor whiteColor]];
    self.maximumDate = [NSDate date];
}

- (void)setupTextColor:(UIColor *)color
{
    [self setValue:color forKeyPath:@"textColor"];
    SEL selector = NSSelectorFromString( @"setHighlightsToday:" );
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature :
                                [UIDatePicker
                                 instanceMethodSignatureForSelector:selector]];
    BOOL no = NO;
    [invocation setSelector:selector];
    [invocation setArgument:&no atIndex:2];
    [invocation invokeWithTarget:self];
}

@end
