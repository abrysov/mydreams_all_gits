//
//  CommonTextField.m
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CommonTextField.h"
#import "Helper.h"

@implementation CommonTextField {
    CALayer *bottomBorder;
    UILabel *label;
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

- (void)localize {
    NSString *placeholder = [Helper localizedStringIfIsCode:self.placeholder];
    if (placeholder) {
        [self setPlaceHolder:placeholder];
    }
}

- (void)initAppearence {
    [self localize];
    
    appearenceColor = [UIColor colorWithRed:0.247 green:0.317 blue:0.710 alpha:1];
    
    //self.font = [UIFont fontWithName:@"Roboto-Light" size:16.0];
    
    self.borderStyle = UITextBorderStyleNone;
    
    bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.frame.size.height + 6, 1000 /*self.frame.size.width*/, 1.0f);
    [self.layer addSublayer:bottomBorder];
    [self setFocus:NO];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 8);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 0, 8);
}

- (void)setPlaceHolder:(NSString *)placeholder {
    UIColor *color = [Helper colorWithHexString:@"#858585"];
    //UIFont *font = [UIFont fontWithName:@"Roboto-Light" size:16.0];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{ NSForegroundColorAttributeName: color/*, NSFontAttributeName: font*/ }];
}

- (void)setFocus:(BOOL)focused {
    if (focused) {
        bottomBorder.backgroundColor = appearenceColor.CGColor;
        if (label) {
            label.textColor = appearenceColor;
        }
    }
    else {
        bottomBorder.backgroundColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1].CGColor;
        if (label) {
            label.textColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1];
        }
    }
}

- (void)setLabel:(UILabel *)label_ {
    label = label_;
    [self onchange:nil];
}

- (void)onchange:(NSString *)value {
    if (!value || [value length] == 0) {
        label.hidden = YES;
    }
    else {
        label.hidden = NO;
    }
}

- (void)triggerchange {
    [self onchange:self.text];
}

- (BOOL)checkConstraints:(NSString **)err {
    if (self.required && [self.text length] < 1) {
        *err = self.requiredMsg;
        return NO;
    }
    if (!self.required && [self.text length] == 0) {
        return YES;
    }
    if ((self.minimum > 0 && [self.text length] < self.minimum) ||
        (self.maximum > 0 && [self.text length] > self.maximum)) {
        *err = self.limitsMsg;
        return NO;
    }
    if (self.pattern && ![Helper isMatchRegex:self.pattern targetString:self.text]) {
        *err = self.patternMsg;
        return NO;
    }
    return YES;
}

- (void)setAppearenceColor:(UIColor *)color {
    appearenceColor = color;
    //[self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

@end
