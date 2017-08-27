//
//  PMAvatarForm.h
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMImageForm : PMBaseModel
@property (strong, nonatomic, readonly) NSNumber *x;
@property (strong, nonatomic, readonly) NSNumber *y;
@property (strong, nonatomic, readonly) NSNumber *width;
@property (strong, nonatomic, readonly) NSNumber *height;
@property (strong, nonatomic, readonly) UIImage *image;
@property (strong, nonatomic, readonly) UIImage *cropedImage;

- (instancetype)initWithImage:(UIImage *)image croppedImage:(UIImage *)croppedImage rect:(CGRect)rect;

@end
