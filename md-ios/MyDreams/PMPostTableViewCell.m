//
//  PMPostTableViewCell.m
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostTableViewCell.h"
#import "DreamTableViewCellStatisticView.h"

@interface PMPostTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *photoUserImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPostImageView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *likesView;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *commentsView;
@property (weak, nonatomic) IBOutlet UILabel *showFullLabel;
@property (assign, nonatomic) BOOL likedByMe;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dreamerActivityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *postActivityIndicator;

@property (strong, nonatomic) RACDisposable *imageDisposable;
@property (strong, nonatomic) RACDisposable *avatarDisposable;

@property (strong, nonatomic) RACDisposable *likedDisposable;
@property (strong, nonatomic) RACDisposable *removeLikeDisposable;
@property (strong, nonatomic) RACSignal *likedSignal;
@property (strong, nonatomic) RACSignal *removeLikeSignal;

@property (strong, nonatomic) NSNumber *postIdx;

@end

@implementation PMPostTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.likesView.button addTarget:self
                              action:@selector(sendRequestToLiked:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self setupLocalization];
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
    
    self.photoUserImageView.image = nil;
    self.photoPostImageView.image = [UIImage imageNamed:@"default_photo"];
    self.photoPostImageView.contentMode = UIViewContentModeCenter;
    [self.postActivityIndicator startAnimating];
    [self.dreamerActivityIndicator startAnimating];
}

- (void)setViewModel:(id<PMPostViewModel>)viewModel
{
    self.postIdx = viewModel.postIdx;
    self.likedByMe = viewModel.likedByMe;
    self.fullNameLabel.text = viewModel.fullNameAndAge;
    self.locationLabel.text = viewModel.dreamerLocation;
    self.timeLabel.text = viewModel.date;
    self.descriptionLabel.text = viewModel.details;
    self.likesView.count = viewModel.likeCount;
    self.commentsView.count = viewModel.commentsCount;
    
    if (viewModel.likedByMe) {
        self.likesView.icon = [UIImage imageNamed:@"post_like_fill_icon"];
    }
    else {
        self.likesView.icon = [UIImage imageNamed:@"post_like_icon"];
    }
    
    @weakify(self);
    self.imageDisposable = [viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoPostImageView.image = image;
        self.photoPostImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.postActivityIndicator stopAnimating];
    }];
    
    if (!viewModel.imageSignal) {
        self.photoPostImageView.image = [UIImage imageNamed:@"default_photo"];
        self.photoPostImageView.contentMode = UIViewContentModeCenter;
        [self.postActivityIndicator stopAnimating];
    }
    
    self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoUserImageView.image = image;
        [self.dreamerActivityIndicator stopAnimating];
    }];
    
    if (!viewModel.avatarSignal) {
        [self.dreamerActivityIndicator stopAnimating];
    }
    
    self.likedSignal = viewModel.likedSignal;
    self.removeLikeSignal = viewModel.removeLikeSignal;
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 420.0f;
}

#pragma mark - private

- (void)sendRequestToLiked:(id)sender
{
    @weakify(self);
    self.likesView.button.enabled = NO;
    if (self.likedByMe) {
        self.removeLikeDisposable = [self.removeLikeSignal subscribeNext:^(id x) {
            @strongify(self);
            self.likesView.button.enabled = YES;
        }];
    }
    else {
        self.likedDisposable = [self.likedSignal subscribeNext:^(id x) {
            @strongify(self);
            self.likesView.button.enabled = YES;
        }];
    }
}

- (void)setupLocalization
{
    self.showFullLabel.text = NSLocalizedString(@"dreambook.post_cell.show_full", nil);
}

- (IBAction)toFullPost:(id)sender
{
    [self.toFullPostCommand execute:self.postIdx];
}

@end
