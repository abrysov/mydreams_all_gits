//
//  PMLoadDataThrobberView.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLoadDataThrobberView.h"

@interface PMLoadDataThrobberView()
@property (weak, nonatomic) IBOutlet UIImageView *loadingIconImageView;
@end

NSString * const kPMLoadDataThrobberViewAnimationKey = @"rotationAnimation";

@implementation PMLoadDataThrobberView

- (void)setIsTransparent:(BOOL)isTransparent
{
    self.backgroundColor = [UIColor clearColor];
}

- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    [self.loadingIconImageView.layer addAnimation:rotationAnimation forKey:kPMLoadDataThrobberViewAnimationKey];
}

- (void)stopAnimation
{
    [self.loadingIconImageView.layer removeAnimationForKey:kPMLoadDataThrobberViewAnimationKey];
}

@end
