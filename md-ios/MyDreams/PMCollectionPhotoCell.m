
//
//  PMCollectionPhotoCell.m
//  MyDreams
//
//  Created by user on 07.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCollectionPhotoCell.h"

@interface PMCollectionPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) RACDisposable *imageDisposable;
@end

@implementation PMCollectionPhotoCell

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
