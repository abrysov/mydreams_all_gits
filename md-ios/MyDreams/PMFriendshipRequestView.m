//
//  PMFriendshipRequestView.m
//  MyDreams
//
//  Created by user on 29.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFriendshipRequestView.h"
#import "UIView+PM.h"
#import "UIColor+MyDreams.h"

@interface PMFriendshipRequestView ()
@property (weak, nonatomic) IBOutlet UIImageView *onlineIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shapeIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *topInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarIndicatorView;
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (strong, nonatomic) RACDisposable *avatarDisposable;
@end

@implementation PMFriendshipRequestView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
        [self.avatarIndicatorView startAnimating];
    }
    return self;
}

- (void)setViewModel:(id<PMFriendshipRequestViewModel>)viewModel
{
    self.dreamerIdx = viewModel.dreamerIdx;
    self.onlineIconImageView.hidden = !viewModel.isOnline;
    self.shapeIconImageView.hidden = !viewModel.isVip;
    self.baseView.borderColor = (viewModel.isVip) ? [UIColor dreambookVipColor] : [UIColor dreambookNormalColor];
    self.onlineIconImageView.backgroundColor = (viewModel.isVip) ? [UIColor dreambookVipColor] : [UIColor dreambookNormalColor];
    self.separatorView.backgroundColor = (viewModel.isVip) ? [[UIColor dreambookVipColor] colorWithAlphaComponent:0.2f] : [[UIColor dreambookNormalColor] colorWithAlphaComponent:0.2f];
    if (viewModel.isVip) {
        [self.addButton setTitleColor:[UIColor dreambookVipColor] forState:UIControlStateNormal];
    }
    else {
        [self.addButton setTitleColor:[UIColor dreambookNormalColor] forState:UIControlStateNormal];
    }
    self.topInfoLabel.text = viewModel.topInfo;
    self.bottomInfoLabel.text = viewModel.bottomInfo;
    
    [self.avatarDisposable dispose];
    @weakify(self);
    self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.avatarImageView.image = image;
        [self.avatarIndicatorView stopAnimating];
    }];
}

- (IBAction)addInFriends:(id)sender
{
    [self.addInFriendsCommand execute:self.dreamerIdx];
}

- (IBAction)rejectFriendshipRequest:(id)sender
{
    [self.rejectFriendshipRequestCommand execute:self.dreamerIdx];
}

@end
