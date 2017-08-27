//
//  LikeUserCell.h
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DreamLike.h"
#import "DreamStamp.h"


@interface LikeUserCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *subnameLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (void)initWithLike:(DreamLike *)like;
- (void)initWithStamp:(DreamStamp *)stamp;

@end
