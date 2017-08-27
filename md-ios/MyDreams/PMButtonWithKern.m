//
//  PMButtonWithKern.m
//  MyDreams
//
//  Created by user on 25.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMButtonWithKern.h"

@implementation PMButtonWithKern

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    if (title) {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:title attributes:@{NSKernAttributeName: @(self.kern),
                                                                                                   NSFontAttributeName: self.titleLabel.font,
                                                                                                   NSForegroundColorAttributeName: [self titleColorForState:state]}];
        [self setAttributedTitle:string forState:state];
    }
    else {
        [super setTitle:title forState:state];
    }
}

- (NSString *)titleForState:(UIControlState)state
{
    return [[self attributedTitleForState:state] string];
}

- (void)setKern:(CGFloat )kern
{
    self->_kern = kern;
    [self updateKern];
}

- (void)updateKern
{
    [self setTitle:[self titleForState:UIControlStateNormal] forState:UIControlStateNormal];
}

@end
