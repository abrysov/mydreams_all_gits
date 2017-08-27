//
//  PMAddFriendButton.m
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddFriendButton.h"
#import "UIColor+MyDreams.h"

@implementation PMAddFriendButton

- (void)setInputState:(PMDreamerSubscriptionType)inputState
{
    self->_inputState = inputState;
    switch (inputState) {
        case PMDreamerSubscriptionTypeSubscriber:
            [self applySubscriberState];
            break;
        case PMDreamerSubscriptionTypeFriend:
            [self applyFriendState];
            break;
        case PMDreamerSubscriptionTypeNope:
        default:
            [self applyNotAddedState];
            break;
    }
}

- (void)applySubscriberState
{
    self.alpha = 0.3f;
    [self setImage:[UIImage imageNamed:@"fill_user_icon.png"] forState:UIControlStateNormal];
}

- (void)applyFriendState
{
    self.alpha = 0.3f;
    [self setImage:[UIImage imageNamed:@"fill_user_icon.png"] forState:UIControlStateNormal];
}

- (void)applyNotAddedState
{
    self.alpha = 1.0f;
    [self setImage:[UIImage imageNamed:@"add_user_icon.png"] forState:UIControlStateNormal];
}

@end
