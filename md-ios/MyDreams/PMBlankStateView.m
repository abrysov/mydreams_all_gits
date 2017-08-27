//
//  PMBlankStateView.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBlankStateView.h"

@interface PMBlankStateView ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@end

@implementation PMBlankStateView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textLabel.text = NSLocalizedString(@"blankstate_view.text", nil);
}

- (void)setIsTransparent:(BOOL)isTransparent
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}

@end
