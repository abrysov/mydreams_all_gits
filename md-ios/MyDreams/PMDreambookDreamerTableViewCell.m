//
//  PMDreambookDreamerTableViewCell.m
//  MyDreams
//
//  Created by user on 24.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookDreamerTableViewCell.h"
#import "PMDreambookDreamerViewModel.h"

@interface PMDreambookDreamerTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *onlineIconImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *avatarIndicatorView;
@property (weak, nonatomic) IBOutlet UILabel *topInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shapeIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *freshLabel;
@property (weak, nonatomic) IBOutlet UIButton *toForeignDreambookButton;
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (strong, nonatomic) RACDisposable *avatarDisposable;
@end

@implementation PMDreambookDreamerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	self.toForeignDreambookButton.hidden = YES;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.avatarDisposable dispose];
    self.avatarImageView.image = nil;
	self.toForeignDreambookButton.hidden = YES;
    [self.avatarIndicatorView startAnimating];
}

- (void)setViewModel:(id<PMDreambookDreamerViewModel>)viewModel
{
    self.dreamerIdx = viewModel.dreamerIdx;
    self.topInfoLabel.text = viewModel.topInfo;
    self.bottomInfoLabel.text = viewModel.bottomInfo;
    self.onlineIconImageView.hidden = !viewModel.isOnline;
    self.shapeIconImageView.hidden = !viewModel.isVip;
    self.freshLabel.hidden = !viewModel.isNew;
    
    @weakify(self);
    self.avatarDisposable = [viewModel.avatarSignal subscribeNext:^(UIImage *image) {
        @strongify(self);
        self.avatarImageView.image = image;
        [self.avatarIndicatorView stopAnimating];
    }];
}

#pragma mark - PMEstimatedRowHeight

+ (CGFloat)estimatedRowHeight
{
    return 66.0f;
}

#pragma mark - private

- (IBAction)toDreambook:(id)sender
{
    [self.toDreambookCommand execute:self.dreamerIdx];
}

- (void)setToDreambookCommand:(RACCommand *)toDreambookCommand
{
	self->_toDreambookCommand = toDreambookCommand;
	self.toForeignDreambookButton.hidden = (self->_toDreambookCommand == nil);
}
@end
