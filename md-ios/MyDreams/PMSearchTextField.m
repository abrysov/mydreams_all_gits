//
//  PMSearchTextField.m
//  MyDreams
//
//  Created by user on 22.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchTextField.h"
#import "UIView+PM.h"
#import "UIFont+MyDreams.h"
#import "UIColor+MyDreams.h"
#import <FrameAccessor/FrameAccessor.h>

@interface PMSearchTextField ()
@property (weak, nonatomic) UIButton *clearTextButton;
@end

@implementation PMSearchTextField

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

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.cornerRadius = self.height / 10;
}

#pragma mark - actions

- (void)clearText
{
    self.text = @"";
}

#pragma private

- (void)setup
{
    [self createRightViewWithClearTextButton];
    self.borderStyle = UITextBorderStyleNone;
    self.textColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor searchTextFieldNormalBackgroundColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder ?: @""
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldTextColor],
                                                                              NSFontAttributeName: [UIFont mainAppFontOfSize:12.0f]}];
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 10)];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:spacerView];
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

@end
