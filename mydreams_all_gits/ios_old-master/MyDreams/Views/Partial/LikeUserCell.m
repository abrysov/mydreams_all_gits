//
//  LikeUserCell.m
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "LikeUserCell.h"
#import "Helper.h"
#import "UIHelpers.h"

@implementation LikeUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [UIHelpers setShadow:self.containerView];
    [self.avatarImageView.layer setCornerRadius:25];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)initWithLike:(DreamLike *)like {
    [Helper setImageView:self.avatarImageView withImageUrl:like.user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", like.user.fullname, like.user.age];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.subnameLabel.text = [dateFormatter stringFromDate:like.date];
}

- (void)initWithStamp:(DreamStamp *)stamp {
    [Helper setImageView:self.avatarImageView withImageUrl:stamp.user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", stamp.user.fullname, stamp.user.age];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yy, HH:mm"];
    self.subnameLabel.text = [dateFormatter stringFromDate:stamp.date];
}

@end
