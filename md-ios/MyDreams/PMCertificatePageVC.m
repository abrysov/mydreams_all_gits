//
//  PMCertificatePageVC.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatePageVC.h"

@interface PMCertificatePageVC ()
@property (weak, nonatomic) IBOutlet UIImageView *certificateImageView;
@property (weak, nonatomic) IBOutlet UILabel *dreamerTopInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamerBottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarIndicator;
@property (weak, nonatomic) IBOutlet UILabel *wishLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;
@property (strong, nonatomic) RACDisposable *imageDisposable;
@end

@implementation PMCertificatePageVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.certificateImageView.image = self.viewModel.certificateImage;
    self.dreamerTopInfoLabel.text = self.viewModel.dreamerTopInfo;
    self.dreamerBottomInfoLabel.text = self.viewModel.dreamerBottomInfo;
    self.wishLabel.text = self.viewModel.wish;
    self.pageLabel.text = self.viewModel.page;
    
    @weakify(self);
    [self.imageDisposable dispose];
    self.imageDisposable = [self.viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.avatarImageView.image = image;
        [self.avatarIndicator stopAnimating];
    }];
}

@end
