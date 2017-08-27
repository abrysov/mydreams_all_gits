//
//  PMLocalityCell.m
//  MyDreams
//
//  Created by user on 24.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalityCell.h"
#import "UIColor+MyDreams.h"

@interface PMLocalityCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *selectedView;
@end

@implementation PMLocalityCell

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

- (void)setViewModel:(id<PMLocalityViewModel>)viewModel
{
    self.titleLabel.text = viewModel.title;
    self.descriptionLabel.text = viewModel.descriptionLocality;
}

@end
