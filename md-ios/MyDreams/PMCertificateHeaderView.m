//
//  PMCertificateHeaderView.m
//  MyDreams
//
//  Created by Alexey Yakunin on 18/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateHeaderView.h"
#import "DreamTableViewCellStatisticView.h"

@interface PMCertificateHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberLikes;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberLaunches;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberComments;

@end

@implementation PMCertificateHeaderView

#pragma mark - properties

- (void)setImage:(UIImage *)image
{
	self.imageView.image = image;
}

- (UIImage *)image
{
	return self.imageView.image;
}

- (void)setText:(NSString *)text
{
	self.textLabel.text = text;
}

-(NSString *)text
{
	return self.textLabel.text;
}

- (void)setLikesCount:(NSInteger)likesCount
{
	self.numberLikes.count = likesCount;
}

- (NSInteger)likesCount
{
	return self.numberLikes.count;
}

- (void)setLaunchesCount:(NSInteger)launchesCount
{
	self.numberLaunches.count = launchesCount;
}

- (NSInteger)launchesCount
{
	return self.numberLaunches.count;
}

- (void)setCommentsCount:(NSInteger)commentsCount
{
	self.numberComments.count = commentsCount;
}

- (NSInteger)commentsCount
{
	return self.numberComments.count;
}

@end