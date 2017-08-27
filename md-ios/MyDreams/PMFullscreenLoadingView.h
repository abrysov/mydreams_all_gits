//
//  PMSendLoadView.h
//  MyDreams
//
//  Created by Alexey Yakunin on 14/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMFullscreenLoadingView : UIView

@property (strong, nonatomic) NSString* infoText;

- (void)show;
- (void)hide;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
