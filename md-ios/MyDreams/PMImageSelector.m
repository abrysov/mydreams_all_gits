//
//  PMImageSelector.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMImageSelector.h"
#import <RSKImageCropper/RSKImageCropper.h>
#import <UIImage_Resize/UIImage+Resize.h>

@interface PMImageSelector () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, RSKImageCropViewControllerDelegate>
@end

@implementation PMImageSelector

- (instancetype)initWithController:(UIViewController *)controller needCrop:(BOOL)needCrop resizeTo:(CGSize)resizeTo
{
    self = [super init];
    if (self) {
        self.controller = controller;
        self.needCrop = needCrop;
        self.resizeTo = resizeTo;
    }
    
    return self;
}

- (void)show
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"image_picker.take_photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
        
        [alertController addAction:takePhotoAction];
    }
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertAction *photoLibraryAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"image_picker.select_photo", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showImagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        [alertController addAction:photoLibraryAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"image_picker.cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:cancelAction];
    
    [self.controller presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    if (self.resizeTo.height > 0 && self.resizeTo.width > 0) {
        image = [image resizedImageToFitInSize:self.resizeTo scaleIfSmaller:NO];
    }
        
    if (self.needCrop) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
        imageCropVC.avoidEmptySpaceAroundImage = YES;
        imageCropVC.delegate = self;
        [picker pushViewController:imageCropVC animated:YES];
    }
    else if(self.delegate && [self.delegate respondsToSelector:@selector(imageSelector:didSelectImage:)]) {
        [self.delegate imageSelector:self didSelectImage:image];
        [self.controller dismissViewControllerAnimated:YES completion:NULL];
    }
}

#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(imageSelector:didSelectImage:croppedImage:cropRect:)]) {
        [self.delegate imageSelector:self didSelectImage:controller.originalImage croppedImage:croppedImage cropRect:cropRect];
    }
    
    [self.controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - private

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self.controller presentViewController:imagePickerController animated:YES completion:NULL];
}

@end
