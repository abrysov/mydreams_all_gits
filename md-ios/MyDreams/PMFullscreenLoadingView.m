//
//  PMSendLoadView.m
//  MyDreams
//
//  Created by Alexey Yakunin on 14/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFullscreenLoadingView.h"
#import "CircleProgressBar.h"
#import "UIColor+MyDreams.h"
#import "UIFont+MyDreams.h"

@interface PMFullscreenLoadingView ()
@property (weak, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *infoTextLabel;
@property (strong, nonatomic) UIWindow* overlayWindow;
@end

@implementation PMFullscreenLoadingView

- (void)awakeFromNib
{
	[self setup];
}

- (void)show
{
	self.frame = [[UIScreen mainScreen] bounds];
	self.overlayWindow.hidden = NO;
	[self.overlayWindow addSubview:self];
}

- (void)hide
{
	if (self.superview)
	{
		[self removeFromSuperview];
	}

	self.overlayWindow.hidden = YES;

	[self.progressBar setProgress:0.0f animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated
{
	[self.progressBar setProgress:progress animated:animated];
}

- (void)setInfoText:(NSString *)infoText
{
	self.infoTextLabel.text = infoText;
}

- (NSString *)infoText
{
	return self.infoTextLabel.text;
}

#pragma mark - private

- (void)setup
{
	self.backgroundColor = [UIColor fullScreenLoadingViewBackgroundColor];
	self.progressBar.hintTextFont = [UIFont mainAppFontOfSize:15.0f];
}
@end
