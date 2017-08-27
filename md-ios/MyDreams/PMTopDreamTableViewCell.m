//
//  PMTopDreamTableViewCell.m
//  MyDreams
//
//  Created by user on 22.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMTopDreamTableViewCell.h"
#import "DreamTableViewCellStatisticView.h"
#import "PMDreamViewModel.h"

@interface PMTopDreamTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoDreamImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *dreamActivityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberLiked;
@property (weak, nonatomic) IBOutlet DreamTableViewCellStatisticView *numberMessages;

@property (strong, nonatomic) RACDisposable *imageDisposable;
@property (strong, nonatomic) RACDisposable *likedDisposable;
@property (strong, nonatomic) RACDisposable *removeLikeDisposable;

@property (strong, nonatomic) RACSignal *likedSignal;
@property (strong, nonatomic) RACSignal *removeLikeSignal;

@property (strong, nonatomic) NSNumber *dreamIdx;
@property (assign, nonatomic) BOOL likedByMe;

@end


@implementation PMTopDreamTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.numberLiked.button addTarget:self
                                action:@selector(sendRequestToLiked:)
                      forControlEvents:UIControlEventTouchUpInside];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.imageDisposable dispose];
    [self.likedDisposable dispose];
    [self.removeLikeDisposable dispose];
    
    self.photoDreamImageView.image = [UIImage imageNamed:@"default_photo"];
    self.photoDreamImageView.contentMode = UIViewContentModeCenter;
    [self.dreamActivityIndicator startAnimating];
}

- (void)setViewModel:(id<PMDreamViewModel>)viewModel
{
    self.positionLabel.text = viewModel.positionString;
    self.titleLabel.text = viewModel.titile;
    self.descriptionLabel.text = viewModel.details;
    
    self.numberLiked.count = viewModel.likeCount;
    self.numberMessages.count = viewModel.commentsCount;
    
    self.likedByMe = viewModel.likedByMe;
    
    if (viewModel.likedByMe) {
        self.numberLiked.icon = [UIImage imageNamed:@"liked_fill_icon"];
    }
    else {
        self.numberLiked.icon = [UIImage imageNamed:@"liked_icon"];
    }
    
    @weakify(self);
    self.imageDisposable = [viewModel.imageSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoDreamImageView.contentMode = image ? UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
        self.photoDreamImageView.image = image ? image : [UIImage imageNamed:@"default_photo"];
        [self.dreamActivityIndicator stopAnimating];
    }];
    
    self.likedSignal = viewModel.likedSignal;
    self.removeLikeSignal = viewModel.removeLikeSignal;
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 750.0f;
}

#pragma mark - private

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

- (IBAction)toFullDream:(id)sender
{
    [self.toFullDreamCommand execute:self.dreamIdx];
}

@end
