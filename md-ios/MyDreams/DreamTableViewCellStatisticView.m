//
//  DreamboxState.m
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "DreamTableViewCellStatisticView.h"

@interface DreamTableViewCellStatisticView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@end

@implementation DreamTableViewCellStatisticView

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
        self.numberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    }
}

- (void)setIcon:(UIImage *)icon
{
    if (self->_icon != icon) {
        self->_icon = icon;
        [self setupIcon:icon];
    }
}

- (void)setupIcon:(UIImage *)icon
{
    self.iconImageView.image = icon;
}

- (void)setContainerBackgroundColor:(UIColor *)containerBackgroundColor
{
	self.containerView.backgroundColor = containerBackgroundColor;
}

- (UIColor *)containerBackgroundColor
{
	return self.containerView.backgroundColor;
}

- (void)setTextColor:(UIColor *)textColor
{
	self.numberLabel.textColor = textColor;
}

- (UIColor *)textColor
{
	return self.numberLabel.textColor;
}
@end
