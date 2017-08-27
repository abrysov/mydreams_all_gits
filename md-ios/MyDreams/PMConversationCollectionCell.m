//
//  PMConversationCollectionCell.m
//  MyDreams
//
//  Created by Alexey Yakunin on 29/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMConversationCollectionCell.h"
#import "UIColor+MyDreams.h"
#import "PMConversationViewModel.h"

@interface PMConversationCollectionCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfMessagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfNewMessagesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIView *onlineView;
@property (weak, nonatomic) IBOutlet UIImageView *shapeIconImageView;
@property (nonatomic, strong) UIColor* color;
@property (strong, nonatomic) RACDisposable *avatarDisposable;
@end

@implementation PMConversationCollectionCell

- (void)awakeFromNib
{
	[super awakeFromNib];
	[self setColor:nil];
}

- (void)prepareForReuse
{
	[super prepareForReuse];
	[self.avatarDisposable dispose];
	self.avatarImageView.image = nil;
	[self.activityIndicator startAnimating];
}

- (void)setViewModel:(id<PMConversationViewModel>)viewModel
{
	self.nameLabel.text = viewModel.name;
	self.textLabel.text = viewModel.lastMessageText;
	self.numberOfMessagesLabel.text = viewModel.numberOfMessages;
	self.numberOfNewMessagesLabel.text = viewModel.numberOfNewMessages;
	self.timeLabel.text = viewModel.dateString;
	
	self.onlineView.hidden = !viewModel.isOnline;
	self.color = viewModel.color;
	
	self.shapeIconImageView.hidden = !viewModel.isVip;
	
	@weakify(self);
	self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
		@strongify(self);
		self.avatarImageView.image = image;
		[self.activityIndicator stopAnimating];
	}];
}

- (void)setColor:(UIColor *)color
{
	self.layer.borderColor = (color != nil) ? color.CGColor : [UIColor conversationCellDefaultBorderColor].CGColor;
	self.onlineView.backgroundColor = color;
}
- (IBAction)details:(UIButton *)sender {
	[self.detailsCommnad execute:nil];
}

@end
