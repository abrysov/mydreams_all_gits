//
//  UIImage+PM.m
//  MyDreams
//
//  Created by Antol Peshkov on 27.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import "UIImage+PM.h"

@implementation UIImage (PM)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    return [self filledRectImageWithColor:color size:CGSizeMake(1.0f, 1.0f)];
}

+ (UIImage *)filledRectImageWithColor:(UIColor *)color size:(CGSize)size
{
    return [self filledRoundedRectImageWithColor:color size:size cornerRadius:0.0f];
}

+ (UIImage *)filledRoundedRectImageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillPath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)
                                 resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)strokedRectImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth
{
    return [self strokedRoundedRectImageWithColor:color size:size lineWidth:lineWidth cornerRadius:0.0f];
}

+ (UIImage *)strokedRoundedRectImageWithColor:(UIColor *)color size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius
{
    CGFloat innerInset = lineWidth / 2; //stroked path is bigger than rect because of additional line width
    CGFloat cornerInset = radius + innerInset;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    rect = CGRectInset(rect, innerInset, innerInset);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerInset, cornerInset, cornerInset, cornerInset)
                                 resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)strokedRoundedRectImageWithColor:(UIColor *)color fill:(UIColor *)fillColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius
{
    CGFloat innerInset = lineWidth / 2; //stroked path is bigger than rect because of additional line width
    CGFloat cornerInset = radius + innerInset;
    
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    rect = CGRectInset(rect, innerInset, innerInset);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGContextFillPath(context);
    
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextSetStrokeColorWithColor(context, [color CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerInset, cornerInset, cornerInset, cornerInset)
                                 resizingMode:UIImageResizingModeStretch];
}

+ (UIImage *)gradientStrokedRectImagetWithStrokeColor:(UIColor *)strokeColor startColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size lineWidth:(CGFloat)lineWidth cornerRadius:(CGFloat)radius
{
    CGFloat innerInset = lineWidth / 2; //stroked path is bigger than rect because of additional line width
    CGFloat cornerInset = radius + innerInset;

    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    rect = CGRectInset(rect, innerInset, innerInset);

    CGFloat scale = [UIScreen mainScreen].scale;

    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(context);

    BOOL startColorOk, endColorOk;
    CGFloat r1,r2,g1,g2,b1,b2,a1,a2;

    startColorOk = [startColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    endColorOk = [endColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];

    if (startColorOk && endColorOk)
    {
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0,1.0};
        CGFloat components[8] = { r1,g1,b1,a1, r2,g2,b2,a2 };

        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, num_locations);
        CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.5), CGPointMake(size.width, 0.5), kCGGradientDrawsAfterEndLocation);

        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }

    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetLineWidth(context, lineWidth);
    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerInset, cornerInset, cornerInset, cornerInset)
                                 resizingMode:UIImageResizingModeStretch];
}


@end
