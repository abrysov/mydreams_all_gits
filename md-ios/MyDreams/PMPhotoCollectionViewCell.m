//
//  PMPhotoCollectionViewCell.m
//  MyDreams
//
//  Created by Иван Ушаков on 12.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotoCollectionViewCell.h"
#import "PMPhotoViewModel.h"

@interface PMPhotoCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) RACDisposable *imageDisposable;
@end

@implementation PMPhotoCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageDisposable dispose];
    self.photoImageView.image = nil;
    [self.activityIndicator startAnimating];
}

- (void)setViewModel:(id<PMPhotoViewModel>)viewModel
{
    @weakify(self);
    self.imageDisposable = [viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoImageView.image = image;
        [self.activityIndicator stopAnimating];
    }];
}

@end
