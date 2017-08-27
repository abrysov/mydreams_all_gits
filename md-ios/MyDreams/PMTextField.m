//
//  PMTextField.m
//  MyDreams
//
//  Created by Иван Ушаков on 02.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTextField.h"
#import "UIView+PM.h"
#import <FrameAccessor/FrameAccessor.h>
#import "UIFont+MyDreams.h"
#import "UIColor+MyDreams.h"
#import "UIView+PM.h"

@interface PMTextField ()
@property (weak, nonatomic) UIButton *clearTextButton;
@end

@implementation PMTextField

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

- (void)setIcon:(UIImage *)icon
{
    if (self->_icon != icon) {
        self->_icon = icon;
        
        [self setLeftViewWithIcon:icon];
    }
}

#pragma mark - actions

- (void)clearText
{
    self.text = @"";
}

#pragma private

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cornerRadius = self.height / 2;
}

- (void)setLeftViewWithIcon:(UIImage *)icon
{
    CGRect leftViewFrame = CGRectMake(0.0f, 0.0f, self.height, self.height);
    UIView *leftView = [[UIView alloc] initWithFrame:leftViewFrame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:icon];
    imageView.viewSize = icon.size;
    imageView.centerY = leftView.height / 2;
    imageView.centerX = leftView.width / 2;
    [leftView addSubview:imageView];
    
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (void)createRightViewWithClearTextButton;
{
    CGRect rightViewFrame = CGRectMake(0.0f, 0.0f, self.height, self.height);
    UIView *rightView = [[UIView alloc] initWithFrame:rightViewFrame];
    
    UIImage *clearTextButtonIcon = [UIImage imageNamed:@"clear_textfield_icon"];
    UIButton *clearTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearTextButton.tintColor = [UIColor whiteColor];
    [clearTextButton setImage:clearTextButtonIcon forState:UIControlStateNormal];
    [clearTextButton addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    clearTextButton.viewSize = clearTextButtonIcon.size;
    clearTextButton.centerY = rightView.height / 2;
    clearTextButton.centerX = rightView.width / 2;
    [rightView addSubview:clearTextButton];
    self.clearTextButton = clearTextButton;
    
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
}

- (void)setup
{
    self.cornerRadius = self.height / 2;
    self.borderStyle = UITextBorderStyleNone;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    
    [self createRightViewWithClearTextButton];
    
    @weakify(self);
    [[[RACSignal merge:@[[self rac_signalForSelector:@selector(setPlaceholder:)],
                         [self rac_signalForSelector:@selector(setInputState:)]]]
        startWith:@YES]
        subscribeNext:^(id x) {
            @strongify(self);
            [self updateAppearanceWithInputState];
        }];
}

- (BOOL)becomeFirstResponder {
    BOOL outcome = [super becomeFirstResponder];
    if (outcome) {
        self.borderWidth = 1.0f;
        self.borderColor = [UIColor textFieldSelectedStateBorderColor];
    }
    return outcome;
}

- (BOOL)resignFirstResponder {
    BOOL outcome = [super resignFirstResponder];
    if (outcome) {
        self.borderWidth = 0.0f;
    }
    return outcome;
}

- (void)updateAppearanceWithInputState
{
    switch (self.inputState) {
        case PMTextFieldInputStateValid:
            [self applyValidInputStateApperance];
            break;
        case PMTextFieldInputStateInvalid:
            [self applyInvalidInputStateApperance];
            break;
        case PMTextFieldInputStateNone:
        default:
            [self applyNormalInputStateApperance];
            break;
    }
}

- (void)applyNormalInputStateApperance
{
    self.backgroundColor = [UIColor textFieldNormalBackgroundColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldTextColor],
                                                                              NSParagraphStyleAttributeName: [self paragraffStyle],
                                                                              NSFontAttributeName: [UIFont mainAppFontOfSize:14.0f]}];
}

- (void)applyValidInputStateApperance
{
    self.backgroundColor = [UIColor textFieldValidBackgroundColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldTextColor],
                                                                              NSParagraphStyleAttributeName: [self paragraffStyle],
                                                                              NSFontAttributeName: [UIFont mainAppFontOfSize:14.0f]}];
}

- (void)applyInvalidInputStateApperance
{
    self.backgroundColor = [UIColor textFieldInvalidBackgroundColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldTextColor],
                                                                              NSParagraphStyleAttributeName: [self paragraffStyle],
                                                                              NSFontAttributeName: [UIFont mainAppFontOfSize:14.0f]}];
}

- (NSParagraphStyle *)paragraffStyle
{
    static NSParagraphStyle *paragraphStyle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc]init] ;
        [mutableParagraphStyle setAlignment:NSTextAlignmentCenter];
        paragraphStyle = [mutableParagraphStyle copy];
    });

    return paragraphStyle;
}

#pragma mark - Layouts

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGFloat leftInset = (self.leftView)? self.leftView.width : self.height;
    CGFloat rightInset = (self.rightView)? self.rightView.width : self.height;
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4.0f, leftInset, 0.0f, rightInset));
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGFloat leftInset = (self.leftView)? self.leftView.width : self.height;
    CGFloat rightInset = (self.rightView)? self.rightView.width : self.height;
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4.0f, leftInset, 0.0f, rightInset));
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    CGFloat leftInset = (self.leftView)? self.leftView.width : self.height;
    CGFloat rightInset = (self.rightView)? self.rightView.width : self.height;
    return UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(4.0f, leftInset, 0.0f, rightInset));
}

@end
