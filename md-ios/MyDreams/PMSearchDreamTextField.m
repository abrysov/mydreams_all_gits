//
//  PMSearchDreamTextField.m
//  MyDreams
//
//  Created by user on 25.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchDreamTextField.h"
#import "UIColor+MyDreams.h"
#import <FrameAccessor/FrameAccessor.h>

@interface PMSearchDreamTextField ()
@property (weak, nonatomic) UIButton *clearTextButton;
@end

@implementation PMSearchDreamTextField

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

- (void)setup
{
    [self createRightViewWithClearTextButton];
}

- (void)setLeftViewWithIcon:(UIImage *)icon
{
    CGRect leftViewFrame = CGRectMake(15.0f, 2.0f, self.height, self.height);
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
    
    UIImage *clearTextButtonIcon = [UIImage imageNamed:@"delete_icon.png"];
    UIButton *clearTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearTextButton.tintColor = [UIColor textFieldDreambookColor];
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

- (void)clearText
{
    self.text = @"";
}

@end
