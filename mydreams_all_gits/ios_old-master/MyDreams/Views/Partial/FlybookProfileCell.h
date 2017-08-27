//
//  FlybookProfileCell.h
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flybook.h"

@interface FlybookProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *diamondLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic) IBOutlet UILabel *subscribersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *launchesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *launchesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isVipImageView;
@property (weak, nonatomic) IBOutlet UIImageView *diamondIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *markerIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *quoteIconImage;


- (void)initUIWith:(Flybook *)flybook;

@end
