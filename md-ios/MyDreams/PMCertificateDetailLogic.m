//
//  PMCertificateDetailLogic.m
//  MyDreams
//
//  Created by Alexey Yakunin on 18/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateDetailLogic.h"
#import "PMCertificateDetailViewModelImpl.h"
#import "PMCertificateDetailContext.h"
#import "PMImageDownloader.h"

@interface PMCertificateDetailLogic ()
@property (nonatomic, strong) PMCertificateDetailViewModelImpl* viewModel;
@property (nonatomic, strong) PMCertificateDetailContext* context;
@end

@implementation PMCertificateDetailLogic
@dynamic context;

- (void)startLogic
{
	self.viewModel = [[PMCertificateDetailViewModelImpl alloc] initWithCertificate:self.context.certificate];
	[self imageDownloaderWithCertificate:self.context.certificate];
	[super startLogic];
}

- (void)imageDownloaderWithCertificate:(PMCertificate *)certificate
{
	@weakify(self);
	NSURL *imageUrl = [NSURL URLWithString:certificate.certifiable.image.large];
	if (imageUrl) {
		[[self.imageDownloader imageForURL:imageUrl] subscribeNext:^(UIImage *image) {
			@strongify(self);
			PMCertificateDetailViewModelImpl *viewModel = self.viewModel;
			viewModel.headerImage = image;
		}];
	}

	NSURL *avatarUrl = [NSURL URLWithString:certificate.giftedBy.avatar.large];
	if (avatarUrl) {
		[[self.imageDownloader imageForURL:avatarUrl] subscribeNext:^(UIImage *image) {
			@strongify(self);
			PMCertificateDetailViewModelImpl *viewModel = self.viewModel;
			viewModel.avatarImage = image;
		}];
	}
}
@end
