//
//  PMFastLinkItemView.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFastLinkItemView.h"

@interface PMFastLinkItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation PMFastLinkItemView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
        
        self.iconImageView.tintColor = self.normalTintColor;
    }
    
    return self;
}

- (void)deselect
{
    self.selected = NO;
    self.iconImageView.tintColor = self.normalTintColor;
}

- (void)select
{
    self.selected = YES;
    self.iconImageView.tintColor = self.selectedTintColor;
}

#pragma mark - properties

- (void)setIcon:(UIImage *)icon
{
    self.iconImageView.image = icon;
}

- (UIImage *)icon
{
    return self.iconImageView.image;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setTextColor:(UIColor *)textColor
{
    self.titleLabel.textColor = textColor;
}

- (UIColor *)textColor
{
    return self.titleLabel.textColor;
}

- (void)setSelectedTintColor:(UIColor *)selectedTintColor
{
    self->_selectedTintColor = selectedTintColor;
    if (self.selected) {
        self.iconImageView.tintColor = self.selectedTintColor;
    }
}

- (void)setNormalTintColor:(UIColor *)normalTintColor
{
    self->_normalTintColor = normalTintColor;
    if (!self.selected) {
        self.iconImageView.tintColor = self.normalTintColor;
    }
}

#pragma mark - actions

- (IBAction)didSelect:(id)sender
{
    [self select];
    if ([self.delegate respondsToSelector:@selector(didSelectFastLinkItemView:)]) {
        [self.delegate didSelectFastLinkItemView:self];
    }
}

@end
