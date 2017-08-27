//
//  PMMenuItemView.m
//  MyDreams
//
//  Created by Иван Ушаков on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMenuItemView.h"
#import <Masonry/Masonry.h>

@interface PMMenuItemView ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@end

@implementation PMMenuItemView

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
    }
    
    return self;
}

- (void)deselect
{
    [self.button setSelected:NO];
}

- (void)select
{
    [self.button setSelected:YES];
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

- (void)setBage:(NSString *)bage
{
    self.badgeLabel.hidden = (bage.length == 0);
    self.badgeLabel.text = bage;
}

- (NSString *)badge
{
    return self.badgeLabel.text;
}

#pragma mark - actions

- (IBAction)didSelect:(id)sender
{
    [self select];
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:self];
    }
}

@end
