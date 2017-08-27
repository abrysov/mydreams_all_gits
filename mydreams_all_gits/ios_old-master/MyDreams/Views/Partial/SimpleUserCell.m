//
//  BasicUserCell.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "SimpleUserCell.h"
#import "Helper.h"
#import "Constants.h"

@implementation SimpleUserCell

- (void)awakeFromNib {
    [self.avatarImageView.layer setCornerRadius:25];
    
    self.nameLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIEdgeInsets)layoutMargins {
    return UIEdgeInsetsZero;
}

- (void)initWithUser:(BasicUser *)user {
    self.nameLabel.text = user.fullname;
    
    [Helper setImageView:self.avatarImageView withImageUrl:user.avatarUrl andDefault:@"_LOGO_IMAGE_BLUE"];
}

@end
