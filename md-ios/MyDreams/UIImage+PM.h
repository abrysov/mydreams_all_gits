//
//  UIImage+PM.h
//  MyDreams
//
//  Created by Antol Peshkov on 27.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PM)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)filledRectImageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)filledRoundedRectImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;
+ (UIImage *)strokedRectImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth;
+ (UIImage *)strokedRoundedRectImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius;
+ (UIImage *)strokedRoundedRectImageWithColor:(UIColor *)color fill:(UIColor *)fillColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius;

#pragma mark - gradient
+ (UIImage *)gradientStrokedRectImagetWithStrokeColor:(UIColor *)strokeColor startColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius;

@end
