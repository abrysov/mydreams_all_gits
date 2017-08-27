//
//  CommonTextView.m
//  MyDreams
//
//  Created by Игорь on 07.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CommonTextView.h"

@implementation CommonTextView {
    //CALayer *bottomBorder;
    //UILabel *placeholderLabel;
    UILabel *inputLabel;
    UIColor *appearenceColor;
}

- (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    if (self) {
        [self initAppearence];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initAppearence];
    }
    return self;
}

- (void)awakeFromNib {
   
    
//    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height + 6, 1000, 10.0f)];
//    [borderView setBackgroundColor:[UIColor yellowColor]];
//    [self.superview addSubview:borderView];
//    
//    bottomBorder = [CALayer layer];
//    bottomBorder.frame = CGRectMake(0.0f, 0, 1000 /*self.frame.size.width*/, 1.0f);
//    //[self.layer addSublayer:bottomBorder];
//    [borderView.layer addSublayer:bottomBorder];
//    
//    [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.viewForBaselineLayout
//                                                          attribute:NSLayoutAttributeBottom
//                                                          relatedBy:0
//                                                             toItem:borderView
//                                                          attribute:NSLayoutAttributeTop
//                                                         multiplier:1.0
//                                                           constant:0]];
}


- (void)initAppearence {
    //[self localize]
    
    self.delegate = self;
    
    appearenceColor = [UIColor colorWithRed:0.247 green:0.317 blue:0.710 alpha:1];
    
    self.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 0);
    self.textContainer.lineFragmentPadding = 0;
    
    [self setFocus:NO];
}

- (void)setAppearenceColor:(UIColor *)color {
    appearenceColor = color;
}

- (void)setFocus:(BOOL)focused {
    if (focused) {
        self.bottomBorder.backgroundColor = appearenceColor;
        if (inputLabel) {
            inputLabel.textColor = appearenceColor;
        }
        
    }
    else {
        self.bottomBorder.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        if (inputLabel) {
            inputLabel.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        }
    }
    if (self.placeholderLabel) {
        self.placeholderLabel.hidden = [self.text length] > 0;
    }
}

- (void)setLabel:(UILabel *)label {
    inputLabel = label;
}

- (void)setPlaceholder:(UILabel *)label {
    self.placeholderLabel = label;
}

- (BOOL)checkConstraints {
    if ((self.minimum > 0 && [self.text length] < self.minimum) || (self.maximum > 0 && [self.text length] > self.maximum)) {
        return NO;
    }
    return YES;
}

- (void)paste:(id)sender {
    [super paste:sender];
}

@end
