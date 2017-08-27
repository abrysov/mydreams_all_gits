//
//  PMSwitchButtonView.m
//  MyDreams
//
//  Created by user on 25.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSwitchButtonView.h"
#import "UIColor+MyDreams.h"

@interface PMSwitchButtonView ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@end

@implementation PMSwitchButtonView
@synthesize inputState = _inputState;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self buildView];
    }
    return self;
}

- (instancetype)initWitBottomLineColor:(UIColor *)color
{
    self = [super init];
    if (self) {
        [self buildView];
        self.separatorView.backgroundColor = color;
        self.button.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.inputState = PMSwitchButtonViewStateInactive;
    }
    return self;
}

- (void)setInputState:(PMSwitchButtonViewState)inputState
{
    self->_inputState = inputState;
    switch (inputState) {
        case PMSwitchButtonViewStateActive:
            [self applyActiveInputState];
            break;
        case PMSwitchButtonViewStateInactive:
        default:
            [self applyInactiveInputState];
            break;
    }
}

- (void)buildView
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
    [self addSubview:view];
    
    @weakify(self);
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self);
    }];
}

- (void)applyActiveInputState
{
    self.separatorView.hidden = NO;
    self.button.alpha = 1;
}

- (void)applyInactiveInputState
{
    self.separatorView.hidden = YES;
    self.button.alpha = 0.3;

}

@end
