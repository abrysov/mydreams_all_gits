//
//  DreamCell.h
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dream.h"
#import "Constants.h"

@interface DreamCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *countersContainer;
@property (weak, nonatomic) IBOutlet UIImageView *launchesIcon;
@property (weak, nonatomic) IBOutlet UILabel *launchesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *likesIcon;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentsIcon;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

- (void)initUIWith:(Dream *)dream andAppearence:(AppearenceStyle)appearence;

@end
