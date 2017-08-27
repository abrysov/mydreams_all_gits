//
//  PMSelectedLocationCell.m
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCountyCell.h"
#import "UIColor+MyDreams.h"

@interface PMCountyCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@end

@implementation PMCountyCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(highlighted) {
        self.selectedView.hidden = NO;
    } else {
        self.selectedView.hidden = YES;
    }
}

- (void)setViewModel:(id<PMCountryViewModel>)viewModel
{
    self.titleLabel.text = viewModel.title;
}

@end
