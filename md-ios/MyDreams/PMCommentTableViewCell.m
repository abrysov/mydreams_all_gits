//
//  PMCommentTableViewCell.m
//  MyDreams
//
//  Created by user on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCommentTableViewCell.h"

@interface PMCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarActivity;
@end

@implementation PMCommentTableViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.avatarImageView.image = nil;
    [self.avatarActivity startAnimating];
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 120.0f;
}

@end
