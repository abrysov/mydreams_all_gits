//
//  PMCertificateDetailVC.m
//  MyDreams
//
//  Created by Alexey Yakunin on 17/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateDetailVC.h"
#import "PMCertificateHeaderView.h"
#import "PMCertificateDetailLogic.h"

@interface PMCertificateDetailVC ()
@property (strong, nonatomic) PMCertificateDetailLogic *logic;
@property (weak, nonatomic) IBOutlet PMCertificateHeaderView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *giftTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *userImageActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIView *markTimeView;
@property (weak, nonatomic) IBOutlet UILabel *markTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *markPriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *markImageView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *giftFromView;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIView *commentView;

@end

@implementation PMCertificateDetailVC
@dynamic logic;

- (void)setupLocalization
{
	[super setupLocalization];
	self.title = [NSLocalizedString(@"dreambook.certificate_detail.title", nil) uppercaseString];
}

- (void)bindUIWithLogics
{
	[super bindUIWithLogics];

	@weakify(self);
	[RACObserve(self.logic.viewModel, isNeedToShowGiftBy) subscribeNext:^(NSNumber* isNeed) {
		@strongify(self);
		if (![isNeed boolValue])
		{
			[self removeGiftBySection];
			self.markTimeView.hidden = NO;
		}
	}];

	RAC(self.headerView, image) = [RACObserve(self.logic, viewModel.headerImage)
									   filter:^BOOL(id value) {
										   return value ? YES : NO;
									   }];

	RAC(self.photoUserImageView, image) = [RACObserve(self.logic, viewModel.avatarImage) doNext:^(id x) {
		@strongify(self);
		[self.userImageActivityIndicator stopAnimating];
	}];
}

- (void)setupUI
{
	[super setupUI];

	[self.userImageActivityIndicator startAnimating];

	self.headerView.text = self.logic.viewModel.title;
	self.headerView.likesCount = self.logic.viewModel.likesCount;
	self.headerView.launchesCount = self.logic.viewModel.launchesCount;
	self.headerView.commentsCount = self.logic.viewModel.commentsCount;

	self.fullNameLabel.text = self.logic.viewModel.dreamerTopInfo;
	self.locationLabel.text = self.logic.viewModel.dreamerBottomInfo;
	self.commentLabel.text = self.logic.viewModel.wish;
	self.giftTimeLabel.text = self.logic.viewModel.date;

	self.markImageView.image = self.logic.viewModel.certificateImage;
	self.markPriceLabel.text = self.logic.viewModel.numberOfLaunches;
	self.markTimeLabel.text = self.logic.viewModel.date;
}

#pragma mark - private

- (void)removeGiftBySection
{
	[self.giftFromView removeFromSuperview];
	[self.userView removeFromSuperview];
	[self.commentView removeFromSuperview];
}
@end
