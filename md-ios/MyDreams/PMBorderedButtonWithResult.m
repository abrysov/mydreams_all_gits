//
//  PMBorderedButtonWithFallOfAlpha.m
//  MyDreams
//
//  Created by user on 04.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButtonWithResult.h"

@implementation PMBorderedButtonWithResult

- (void)setInputState:(PMBorderedButtonWithResultState)inputState
{
    switch (inputState) {
        case PMBorderedButtonWithResultStateActive:
            [self applyActiveInputState];
            break;
        case PMBorderedButtonWithResultStateInactive:
        default:
            [self applyInactiveInputState];
            break;
    }
}

- (void)applyActiveInputState
{
    self.enabled = YES;
    self.alpha = 1.0f;
}

- (void)applyInactiveInputState
{
    self.enabled = NO;
    [self setTitle:NSLocalizedString(@"dreambook.filters_dreamers.send_button_title_not_found", nil) forState:UIControlStateNormal];
    self.alpha = 0.5f;
}

@end
