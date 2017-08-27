//
//  UserListCell.m
//  MyDreams
//
//  Created by Игорь on 18.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UserListCell.h"
#import "Helper.h"

@implementation UserListCell

- (void)awakeFromNib {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.containerView.frame.size.height, self.containerView.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1].CGColor;
    [self.containerView.layer addSublayer:bottomBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)initUIWith:(BasicUser *)user {
    [Helper setImageView:self.avatarImageView withImageUrl:user.avatarUrl andDefault:(user.isVip ? @"dummy-purple": @"dummy-blue")];
    self.avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@, %@", user.fullname, user.age];
    self.locationLabel.text = user.location;
    
    self.markerIconImage.image = [UIImage imageNamed:user.isVip ? @"map-marker-purple" : @"map-marker-blue"];
    self.userIconImage.image = [UIImage imageNamed:user.isVip ? @"account-purple" : @"account-blue"];
}

@end
