//
//  EventFeedPhotosViewCell.h
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EventFeed.h"

@interface EventFeedPhotosCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *subnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *photosContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosContainerHeight;

- (void)initUIWith:(EventFeedItem *)event;

@end
