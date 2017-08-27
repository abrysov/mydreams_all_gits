//
//  PMSwipeButton.m
//  MyDreams
//
//  Created by Alexey Yakunin on 03/08/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSwipeButton.h"

@implementation PMSwipeButton

+(instancetype) buttonWithTitle:(NSString *) title backgroundColor:(UIColor *) color callback:(PMSwipeButtonCallback) callback
{
	PMSwipeButton * button = [self buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = color;
	button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
	button.titleLabel.textAlignment = NSTextAlignmentCenter;
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	button.callback = callback;
	return button;
}

@end
