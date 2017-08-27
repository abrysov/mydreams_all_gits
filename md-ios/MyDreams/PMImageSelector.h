//
//  PMImageSelector.h
//  MyDreams
//
//  Created by Иван Ушаков on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMImageSelector;

@protocol PMImageSelectorDelegate <NSObject>
@optional
- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image;
- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect;
@end

@interface PMImageSelector : NSObject
@property (weak, nonatomic) UIViewController *controller;
@property (assign, nonatomic) BOOL needCrop;
@property (assign, nonatomic) CGSize resizeTo;
@property (weak, nonatomic) id<PMImageSelectorDelegate> delegate;

- (instancetype)initWithController:(UIViewController *)controller needCrop:(BOOL)needCrop resizeTo:(CGSize)resizeTo;
- (void)show;
@end
