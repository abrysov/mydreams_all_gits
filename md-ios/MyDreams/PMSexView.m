//
//  PMSexView.m
//  MyDreams
//
//  Created by user on 21.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSexView.h"
#import "UIColor+MyDreams.h"

@interface PMSexView ()
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UIView *botSeparator;
@end

@implementation PMSexView

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
    }
    return self;
}

#pragma mark - properties

- (void)setInputState:(PMSexViewInputState)inputState
{
    self->_inputState = inputState;
    switch (inputState) {
        case PMSexViewInputStateNone:
            self.titleButton.alpha = 0.3;
            self.botSeparator.alpha = 0.3;
            self.botSeparator.backgroundColor = [UIColor whiteColor];
            [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.titleButton.userInteractionEnabled = YES;
            break;
        case PMSexViewInputStateInvalid:
            self.titleButton.alpha = 0.3;
            self.botSeparator.alpha = 1;
            self.botSeparator.backgroundColor = [UIColor invalidStateColor];
            [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.titleButton.userInteractionEnabled = YES;
            break;
        case PMSexViewInputStateSelected:
            self.titleButton.alpha = 1;
            self.botSeparator.alpha = 1;
            self.botSeparator.backgroundColor = [UIColor whiteColor];
            [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.titleButton.userInteractionEnabled = NO;
            break;
    }
}

@end
