//
//  CellSettingsView.m
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "CellSettingsView.h"
#import "UIColor+MyDreams.h"

@interface CellSettingsView()
@property (strong, nonatomic) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBetweenIconAndLabel;

@property (assign, nonatomic) BOOL isEditing;
@end

@implementation CellSettingsView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.view];
        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        self.valueTextField.tintColor = [UIColor settingsBaseColor];
    }
    return self;
}

#pragma makr - properties

- (void)setInputState:(PMCellSettingsViewInputState)inputState
{
    self->_inputState = inputState;
    [self updateViewWithState:inputState isEditing:self.isEditing];
}

- (void)setLabelColor:(UIColor *)labelColor
{
    self->_labelColor = labelColor;
    self.titleLabel.textColor = labelColor;
}

- (void)setIcon:(UIImage *)icon
{
    if (self->_icon != icon) {
        self->_icon = icon;
        self.iconImageView.image = icon;
        self.constraintBetweenIconAndLabel.constant = 14.0f;
    }
}

- (void)setHideSeparator:(BOOL)hideSeparator
{
    self->_hideSeparator = hideSeparator;
    self.separatorView.hidden = hideSeparator;
}

- (void)setDisableTextField:(BOOL)disableTextField
{
    self->_disableTextField = disableTextField;
    self.valueTextField.enabled = !disableTextField;
}

#pragma mark - actions

- (IBAction)beginEditingTextField:(id)sender
{
    [self.valueTextField becomeFirstResponder];
}

- (IBAction)editingDidBeginTextField:(id)sender
{
    self.isEditing = YES;
    [self updateViewWithState:self.inputState isEditing:self.isEditing];
}

- (IBAction)editingDidEndTextField:(id)sender
{
    self.isEditing = NO;
    [self updateViewWithState:self.inputState isEditing:self.isEditing];
}

#pragma mark - private

- (void)updateViewWithState:(PMCellSettingsViewInputState)inputState isEditing:(BOOL)isEditing
{
    switch (inputState) {
        case PMCellSettingsViewInputStateInvalid:
            self.separatorView.backgroundColor = [UIColor settingsTextfieldInvalidStateColor];
            break;
            
        case PMCellSettingsViewInputStateNone:
        default:
            self.separatorView.backgroundColor = (isEditing) ? [UIColor settingsTextfieldActiveStateColor] : [UIColor settingsTextfieldDefaultStateColor];
            break;
    }
}

@end
