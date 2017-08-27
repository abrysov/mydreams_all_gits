//
//  PMCollectionCertificateCell.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCollectionCertificateCell.h"

@interface PMCollectionCertificateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (strong, nonatomic) RACDisposable *imageDisposable;
@end

@implementation PMCollectionCertificateCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageDisposable dispose];
    self.backgroundImageView.image = nil;
    self.certificateImageView.image = nil;
}

- (void)setViewModel:(id<PMCertificateViewModel>)viewModel
{
    self.certificateImageView.image = viewModel.certificateImage;
    
    @weakify(self);
    self.imageDisposable = [viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.backgroundImageView.image = image;
    }];
}
@end
