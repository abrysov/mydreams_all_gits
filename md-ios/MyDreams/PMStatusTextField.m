//
//  PMStatusTextField.m
//  MyDreams
//
//  Created by user on 19.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMStatusTextField.h"
#import "UIColor+MyDreams.h"

@implementation PMStatusTextField

- (void)setup
{
    [self updateAppearanceWithInputState:self.inputState];
}

- (void)setInputState:(PMStatusTextFieldInputState)inputState
{
    [self updateAppearanceWithInputState:inputState];
}

- (void)updateAppearanceWithInputState:(PMStatusTextFieldInputState)state
{
    switch (state) {
        case PMStatusTextFieldInputStateFull:
            [self applyFullInputStateApperance];
            break;
        case PMStatusTextFieldInputStateClear:
            [self applyClearInputStateApperance];
            break;
        default:
            break;
    }
}

- (void)applyFullInputStateApperance
{

    CGRect rightViewFrame = CGRectMake(0, 0, 25, 14);
    [self enableAndCreateRightViewWithFrame:rightViewFrame];
    self.rightView.alpha = 0.3;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString: @""
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldPlaceholder],
                                                                              }];
}

- (void)applyClearInputStateApperance
{
    CGRect rightViewFrame = CGRectMake(0, 0, 20, 14);
    [self enableAndCreateRightViewWithFrame:rightViewFrame];
    self.rightView.alpha = 1;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"dreambook.header.status_placeholder", nil)
                                                                 attributes:@{NSForegroundColorAttributeName: [UIColor textFieldPlaceholder],
                                                                              }];
}

- (void)enableAndCreateRightViewWithFrame:(CGRect)rightViewFrame
{
    self.rightViewMode = UITextFieldViewModeUnlessEditing;
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:rightViewFrame];
    imageView.image = [UIImage imageNamed:@"edit_icon.png"];
    imageView.contentMode = UIViewContentModeTopRight;
    self.rightView = imageView;
}

@end
