//
//  PMDreamerTableViewCell.m
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerTableViewCell.h"
#import "PMAddFriendButton.h"

@interface PMDreamerTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *ageAndLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankIconLabel;
@property (weak, nonatomic) IBOutlet PMAddFriendButton *addFriendButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *onlineIconImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (strong, nonatomic) RACSignal *friendshipSignal;
@property (strong, nonatomic) RACSignal *desctroyFriendshipRequestSignal;

@property (strong, nonatomic) RACDisposable *avatarDisposable;
@property (strong, nonatomic) RACDisposable *friendshipRequestDisposable;
@property (strong, nonatomic) RACDisposable *destroyFriendshipRequestDisposable;

@property (strong, nonatomic) NSNumber *dreamerIdx;
@end

@implementation PMDreamerTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.addFriendButton.inputState = PMDreamerSubscriptionTypeNope;
}

- (void)layoutSubviews
{
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.avatarDisposable dispose];
    [self.friendshipRequestDisposable dispose];
    [self.destroyFriendshipRequestDisposable dispose];
    
    self.photoImageView.image = nil;
    [self.activityIndicator startAnimating];
}

- (void)setViewModel:(id<PMDreamerViewModel>)viewModel
{
    self.dreamerIdx = viewModel.dreamerIdx;
    self.fullNameLabel.text = viewModel.fullName;
    self.genderIconImageView.image = viewModel.genderImage;
    self.ageAndLocationLabel.text = viewModel.dreamerDetails;
    
    viewModel.isVip ? (self.rankIconLabel.text = NSLocalizedString(@"dreambook.list_dreamers.description_vip_dreamer", nil)) : (self.rankIconLabel.text = @"");
    viewModel.isOnline ? (self.onlineIconImageView.hidden = NO) : (self.onlineIconImageView.hidden = YES);
    
    @weakify(self);
    self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.photoImageView.image = image;
        [self.activityIndicator stopAnimating];
    }];
    
    self.addFriendButton.inputState = viewModel.subscriptionType;
    
    self.friendshipSignal = viewModel.friendshipRequestSignal;
    self.desctroyFriendshipRequestSignal = viewModel.destroyFriendshipRequestSignal;
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 66.0f;
}

#pragma mark - private

- (IBAction)sendFriendshipRequest:(PMAddFriendButton *)sender
{
    self.addFriendButton.enabled = NO;
    @weakify(self);
    switch (sender.inputState) {
        case PMDreamerSubscriptionTypeSubscriber:
        case PMDreamerSubscriptionTypeFriend: {
            self.destroyFriendshipRequestDisposable = [self.desctroyFriendshipRequestSignal subscribeNext:^(id x) {
                @strongify(self);
                self.addFriendButton.enabled = YES;
            } error:^(NSError *error) {
                @strongify(self);
                self.addFriendButton.enabled = YES;
            }];
            break;
        }
        case PMDreamerSubscriptionTypeNope:
        default: {
            self.friendshipRequestDisposable = [self.friendshipSignal subscribeNext:^(id x) {
                @strongify(self);
                self.addFriendButton.enabled = YES;
            } error:^(NSError *error) {
                @strongify(self);
                self.addFriendButton.enabled = YES;
            }];
            break;
        }
    }
}

- (IBAction)toDreambook:(id)sender
{
    [self.toDreambookCommand execute:self.dreamerIdx];
}

@end
