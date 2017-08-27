//
//  PMAvatarForm.m
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMImageForm.h"
#import <Mantle/Mantle.h>
#import "PMAPIClient.h"
#import "PMFile.h"

@interface PMImageForm ()
@property (strong, nonatomic) NSNumber *x;
@property (strong, nonatomic) NSNumber *y;
@property (strong, nonatomic) NSNumber *width;
@property (strong, nonatomic) NSNumber *height;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImage *cropedImage;
@end

@implementation PMImageForm

- (instancetype)initWithImage:(UIImage *)image croppedImage:(UIImage *)croppedImage rect:(CGRect)rect
{
    self = [super init];
    if (self) {
        self.image = image;
        self.cropedImage = croppedImage;
        self.x = @(rect.origin.x);
        self.y = @(rect.origin.y);
        self.width = @(rect.size.width);
        self.height = @(rect.size.height);
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(x): @"crop[x]",
             PMSelectorString(y):@"crop[y]",
             PMSelectorString(width):@"crop[width]",
             PMSelectorString(height): @"crop[height]",
             PMSelectorString(image): @"file",
             PMSelectorString(cropedImage): @"cropped_file",
             };
}

+ (NSValueTransformer *)imageJSONTransformer {
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        *success = YES;
        return [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(value, 0.8f) mimeType:@"image/jpeg"];
    }];
}

+ (NSValueTransformer *)cropedImageJSONTransformer {
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        *success = YES;
        return [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(value, 0.8f) mimeType:@"image/jpeg"];
    }];
}

@end
