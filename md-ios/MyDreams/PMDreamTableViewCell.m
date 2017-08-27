//
//  Dreambox.m
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamTableViewCell.h"
#import "DreamTableViewCellStatisticView.h"
#import "PMDreamViewModel.h"

@interface PMDreamTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;

@property (weak, nonatomic) IBOutlet UIImageView *photoDreamImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dreamerActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dreamActivityIndicator;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberLiked;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberMessages;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberStarts;

@property (strong, nonatomic) RACDisposable *imageDisposable;
@property (strong, nonatomic) RACDisposable *avatarDisposable;
@property (strong, nonatomic) RACDisposable *likedDisposable;
@property (strong, nonatomic) RACDisposable *removeLikeDisposable;

@property (strong, nonatomic) RACSignal *likedSignal;
@property (strong, nonatomic) RACSignal *removeLikeSignal;

@property (strong, nonatomic) NSNumber *dreamIdx;
@property (assign, nonatomic) BOOL likedByMe;

@end

@implementation PMDreamTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.numberLiked.button addTarget:self
                        action:@selector(sendRequestToLiked:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)layoutSubviews
{
    self.photoUserImageView.layer.cornerRadius = self.photoUserImageView.frame.size.width / 2;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageDisposable dispose];
    [self.avatarDisposable dispose];
    [self.likedDisposable dispose];
    [self.removeLikeDisposable dispose];
    
    self.photoDreamImageView.image = [UIImage imageNamed:@"default_photo"];
    self.photoDreamImageView.contentMode = UIViewContentModeCenter;
    self.photoUserImageView.image = nil;
    [self.dreamActivityIndicator startAnimating];
    [self.dreamerActivityIndicator startAnimating];
}

- (void)setViewModel:(id<PMDreamViewModel>)viewModel
{
    self.dreamIdx = viewModel.dreamIdx;
    self.fullNameLabel.text = viewModel.fullName;
    self.userInfoLabel.text = viewModel.dreamerDetails;
    self.vipLabel.text = viewModel.certificateType;
    
    self.genderIconImageView.image = viewModel.genderImage;
    
    self.timeLabel.text = viewModel.date;
    
    self.titleLabel.text = viewModel.titile;
    self.descriptionLabel.text = viewModel.details;
    
    self.numberLiked.count = viewModel.likeCount;
    self.numberMessages.count = viewModel.commentsCount;
    self.numberStarts.count = viewModel.lounchCount;
    
    self.likedByMe = viewModel.likedByMe;
    
    if (viewModel.likedByMe) {
        self.numberLiked.icon = [UIImage imageNamed:@"liked_fill_icon"];
    }
    else {
        self.numberLiked.icon = [UIImage imageNamed:@"liked_icon"];
    }
    
    if (self.staticColor) {
        self.vipLabel.textColor = self.staticColor;
        self.lineView.backgroundColor = self.staticColor;
    }
    else {
        self.vipLabel.textColor = viewModel.color;
        self.lineView.backgroundColor = viewModel.color;
    }
    
    @weakify(self);
    self.imageDisposable = [viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoDreamImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoDreamImageView.image = image;
        [self.dreamActivityIndicator stopAnimating];
    }];
    
    self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoUserImageView.image = image;
        [self.dreamerActivityIndicator stopAnimating];
    }];
    
    self.likedSignal = viewModel.likedSignal;
    self.removeLikeSignal = viewModel.removeLikeSignal;
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 500.0f;
}

#pragma mark - private

- (IBAction)toFullDream:(id)sender
{
    [self.toFullDreamCommand execute:self.dreamIdx];
}

- (void)sendRequestToLiked:(id)sender
{
    @weakify(self);
    self.numberLiked.button.enabled = NO;
    if (self.likedByMe) {
        self.removeLikeDisposable = [self.removeLikeSignal subscribeNext:^(id x) {
            @strongify(self);
            self.numberLiked.button.enabled = YES;
        } error:^(NSError *error) {
            @strongify(self);
            self.numberLiked.button.enabled = YES;
        }];
    }
    else {
        self.likedDisposable = [self.likedSignal subscribeNext:^(id x) {
            @strongify(self);
            self.numberLiked.button.enabled = YES;
        } error:^(NSError *error) {
            @strongify(self);
            self.numberLiked.button.enabled = YES;
        }];
    }
}

@end
