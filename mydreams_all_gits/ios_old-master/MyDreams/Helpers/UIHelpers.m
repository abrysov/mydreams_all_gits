//
//  UIHelpers.m
//  MyDreams
//
//  Created by Игорь on 29.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIHelpers.h"
#import "MDTabBar.h"

@implementation UIHelpers

+ (UIImage *)fixOrientation:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

+ (void)setShadow:(UIView *)view {
    [view.layer setShadowOffset:CGSizeMake(0, 1)];
    [view.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [view.layer setShadowOpacity:0.4];
    [view.layer setShadowRadius:1.4];
    [view.layer setCornerRadius:3];
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = UIScreen.mainScreen.scale;
}

+ (void)setTabBarAppearence:(MDTabBar *)tabBar {
    UIFont *textFontNormal = [UIFont fontWithName:@"Roboto-Light" size:15];
    UIFont *textFontSelected = [UIFont fontWithName:@"Roboto-Bold" size:15];
    UIColor *textColor = [UIColor whiteColor];
    
    UISegmentedControl *segmentedControl = [tabBar valueForKey:@"segmentedControl"];
    
    [segmentedControl setTitleTextAttributes:@{
                                               NSForegroundColorAttributeName: textColor,
                                               NSFontAttributeName: textFontNormal
                                               } forState:UIControlStateNormal];
    
    [segmentedControl setTitleTextAttributes:@{
                                               NSForegroundColorAttributeName: textColor,
                                               NSFontAttributeName: textFontSelected
                                               } forState:UIControlStateSelected];
}

@end