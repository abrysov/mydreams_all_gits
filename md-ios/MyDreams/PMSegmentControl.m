//
//  PMSegmentControl.m
//  MyDreams
//
//  Created by user on 25.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSegmentControl.h"
#import "PMSwitchButtonView.h"
#import "PMSwitchButton.h"

@interface PMSegmentControl ()
@property (nonatomic, assign) NSUInteger currentActive;
@property (nonatomic, strong) NSMutableArray<id<PMSwitchButton>> *buttons;
@property (nonatomic, weak) UIStackView *stackView;
@end

@implementation PMSegmentControl

- (instancetype)initWithItems:(NSArray *)items bottomLineColor:(UIColor *)color class:(id)xibClass
{
    self = [super init];
    if (self) {
        [self createStackViewWithItems:items bottomLineColor:color class:xibClass];
    }
    return self;
}

- (void)setSpacing:(CGFloat)spacing
{
    self->_spacing = spacing;
    self.stackView.spacing = spacing;
}

- (void)createStackViewWithItems:(NSArray *)items bottomLineColor:(UIColor *)color class:class
{
    UIStackView *stackView = [[UIStackView alloc] init];
    self.buttons = [[NSMutableArray alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.alignment = UIStackViewAlignmentCenter;
    
    
    for (NSString *title in items) {
        [self addButtonWithTitle:title on:stackView bottomColor:color class:class];
    }
    [self addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.stackView = stackView;
    self.buttons[0].inputState = PMSwitchButtonViewStateActive;
}

- (void)addButtonWithTitle:(NSString *)title on:(UIStackView *)stackView bottomColor:(UIColor *)color class:(id)class
{
    PMSwitchButtonView *switchButtonView = [[class alloc] initWitBottomLineColor:color];
    [switchButtonView.button setTitle:title forState:UIControlStateNormal];
    [stackView addArrangedSubview:switchButtonView];
    [self.buttons addObject:switchButtonView];
    [switchButtonView.button addTarget:self action:@selector(pressedButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)pressedButton:(UIButton *)button
{
    int index = 0;
    for (int i = 0; i < self.buttons.count; i++) {
        if ([self.buttons[i].button isEqual:button]) {
            index = i;
            break;
        }
    }
    [self changeSegmentOn:index];
    [self.delegate SegmentControl:self SwitchedOn:index];
}

- (void)changeSegmentOn:(NSInteger)index
{
    id<PMSwitchButton> switchButtonViewOld = self.buttons[self.currentActive];
    switchButtonViewOld.inputState = PMSwitchButtonViewStateInactive;
    id<PMSwitchButton> switchButtonView =self.buttons[index];
    switchButtonView.inputState = PMSwitchButtonViewStateActive;
    self.currentActive = index;
}

@end
