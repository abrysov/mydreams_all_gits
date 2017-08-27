//
//  PMStateDreambookView.m
//  MyDreams
//
//  Created by user on 18.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookHeaderViewItemView.h"

@interface PMDreambookHeaderViewItemView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@end

@implementation PMDreambookHeaderViewItemView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
    }
    return self;
}

- (void)setCount:(NSUInteger)count
{
    if (self->_count != count) {
        self->_count = count;
        self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    }
}

- (void)setTitle:(NSString *)title
{
    if (self->_title != title) {
        self->_title = title;
        self.titleLabel.text = title;
    }
}

- (void)setIcon:(UIImage *)icon
{
    if (self->_icon != icon) {
        self->_icon = icon;
        self.iconImageView.image = icon;
    }
}

- (void)setBadgeValue:(NSInteger)badgeValue
{
    self->_badgeValue = badgeValue;
    self.badgeLabel.text = [NSString stringWithFormat:@"%@",@(badgeValue)];
    if (badgeValue != 0) {
        self.badgeLabel.hidden = NO;
    }
    else {
        self.badgeLabel.hidden = YES;
    }
}

#pragma mark - actions

- (IBAction)pressedButton:(id)sender
{
    [self.buttonCommand execute:@(self.type)];
}

@end
