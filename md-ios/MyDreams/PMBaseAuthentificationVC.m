//
//  PMBaseAuthorizationVC.m
//  MyDreams
//
//  Created by user on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseAuthentificationVC.h"
#import "PMLoadDataThrobberView.h"
#import "PMBlankStateView.h"
#import "PMLoadDataErrorView.h"

@interface PMBaseAuthentificationVC ()

@end

@implementation PMBaseAuthentificationVC

- (NSInteger)toastTopMargin
{
    return 64;
}

- (void)setIsStateViewTransparent:(BOOL)isStateViewTransparent
{
    if (self -> _isStateViewTransparent != isStateViewTransparent) {
        self -> _isStateViewTransparent = isStateViewTransparent;
        self.loadDataThrobberView.isTransparent = isStateViewTransparent;
        self.blankStateView.isTransparent = isStateViewTransparent;
        self.loadDataErrorView.isTransparent = isStateViewTransparent;
    }
}

- (void)setStateViewTextColor:(UIColor *)stateViewTextColor
{
    if (self -> _stateViewTextColor != stateViewTextColor) {
        self -> _stateViewTextColor = stateViewTextColor;
        self.blankStateView.textColor = stateViewTextColor;
        self.loadDataErrorView.textColor = stateViewTextColor;
    }
}

@end
