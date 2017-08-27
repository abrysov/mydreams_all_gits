//
//  CommonTextView.h
//  MyDreams
//
//  Created by Игорь on 07.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonTextView : UITextView<UITextViewDelegate>

@property (nonatomic) NSInteger minimum;
@property (nonatomic) NSInteger maximum;

@property (weak, nonatomic) UIView *bottomBorder;
@property (weak, nonatomic) UIView *placeholderLabel;

- (void)setFocus:(BOOL)focused;
- (void)setLabel:(UILabel *)label;
- (void)setPlaceholder:(UILabel *)label;
- (BOOL)checkConstraints;
- (void)setAppearenceColor:(UIColor *)color;

@end
