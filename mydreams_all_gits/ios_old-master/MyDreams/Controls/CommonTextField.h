//
//  CommonTextField.h
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CommonTextField : UITextField<UITextFieldDelegate>

@property (nonatomic) BOOL required;
@property (retain, nonatomic) NSString *requiredMsg;

@property (nonatomic) NSInteger minimum;
@property (nonatomic) NSInteger maximum;
@property (retain, nonatomic) NSString *limitsMsg;

@property (retain, nonatomic) NSString *pattern;
@property (retain, nonatomic) NSString *patternMsg;

- (void)setFocus:(BOOL)focused;
- (void)setLabel:(UILabel *)label;
- (void)onchange:(NSString *)value;
- (void)triggerchange;
- (BOOL)checkConstraints:(NSString **)err;
- (void)setAppearenceColor:(UIColor *)color;

@end
