//
//  PMCellFillView.m
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCellFillView.h"
#import "UIColor+MyDreams.h"

@interface PMCellFillView ()
@property (strong, nonatomic) UIView *view;
@property (weak, nonatomic) IBOutlet UIView *separatorView;

@property (assign, nonatomic) BOOL isEditing;
@end


@implementation PMCellFillView

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
        self.valueTextField.tintColor = [UIColor whiteColor];
    }
    return self;
}

#pragma makr - properties

- (void)setInputState:(PMCellFillViewInputState)inputState
{
    self->_inputState = inputState;
    [self updateViewWithState:inputState isEditing:self.isEditing];
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

- (void)updateViewWithState:(PMCellFillViewInputState)inputState isEditing:(BOOL)isEditing
{
    switch (inputState) {
        case PMCellFillViewInputStateInvalid:
            self.separatorView.backgroundColor = [UIColor invalidStateColor];
            self.separatorView.alpha = 1.0f;
            break;
            
        case PMCellFillViewInputStateValid:
        case PMCellFillViewInputStateNone:
        default:
            self.separatorView.backgroundColor = [UIColor whiteColor];
            self.separatorView.alpha = (isEditing) ? 1.0f : 0.3f;
            break;
    }
}

@end
