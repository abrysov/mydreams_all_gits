//
//  PMSearchDreamView.m
//  MyDreams
//
//  Created by Anatoliy Peshkov on 22/06/2016.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSearchView.h"
#import "UITextField+PM.h"

@interface PMSearchView ()
@property (weak, nonatomic) IBOutlet UIView *backSearchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *cancelSearchButton;
@property (weak, nonatomic) IBOutlet UIButton *activateTextFieldButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botConstraint;
@end

@implementation PMSearchView

- (void)establishChannelToTextWithTerminal:(RACChannelTerminal *)otherTerminal
{
    [self.searchTextField establishChannelToTextWithTerminal:otherTerminal];
}

- (void)setPlaceholder:(NSString *)placeholder
{
	[self.activateTextFieldButton setTitle:placeholder  forState:UIControlStateNormal];
}

- (NSString *)placeholder
{
	return [self.activateTextFieldButton titleForState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (self.searchTextField == textField && [textField.text isEqualToString:@""]) {
        [self hideSearchView:nil];
    }
    return YES;
}

#pragma mark - private

- (IBAction)hideSearchView:(id)sender
{
    self.searchTextField.text = @"";
    [self.searchTextField resignFirstResponder];
    self.activateTextFieldButton.hidden = NO;
    self.botConstraint.priority = 850;
    self.backSearchView.hidden = YES;
}

- (IBAction)showSearchView:(id)sender
{
    self.activateTextFieldButton.hidden = YES;
    [self.searchTextField becomeFirstResponder];
    self.botConstraint.priority = 999;
    self.backSearchView.hidden = NO;
}

@end
