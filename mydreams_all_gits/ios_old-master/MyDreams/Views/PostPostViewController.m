//
//  PostPostViewController.m
//  MyDreams
//
//  Created by Игорь on 09.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "PostPostViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageFilters/ImageFilter.h>
#import "UIHelpers.h"
#import "Helper.h"
#import "Constants.h"
#import "ApiDataManager.h"
#import "AppDelegate.h"
#import "CommonTextView.h"
#import "ImageCropView.h"
#import "Post.h"

/* PostDreamsViewController copypaste */

@interface PostPostViewController ()
@end


@implementation PostPostViewController {
    UIImage *currentPickedImage;
    UIImage *currentPickedImageScaled;
    NSInteger selectedFilter;
    Post *post;
    NSString *dummyImageName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *getPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhotoBrowser)];
    [self.getPhotoButton addGestureRecognizer:getPhoto];
    self.getPhotoButton.userInteractionEnabled = YES;
    
    self.filtersView.hidden = YES;
    self.filtersViewHeight.constant = 0;
    
    [self.dreamDescTextView setPlaceholder:self.dreamDescTextViewLabel];
    self.dreamDescTextView.bottomBorder = self.dreamDescTextViewBorder;
    self.dreamDescTextView.minimum = 3;
    self.dreamDescTextView.maximum = 500;
    [self.dreamDescTextView setAppearenceColor:[self appearenceColor]];
    
    self.dreamTitleTextField.required = YES;
    self.dreamTitleTextField.requiredMsg = [Helper localizedString:@"_POST_ADD_TITLE_NO"];
    self.dreamTitleTextField.minimum = 3;
    self.dreamTitleTextField.maximum = 160;
    self.dreamTitleTextField.limitsMsg = [Helper localizedString:@"_POST_ADD_TITLE_NO"];
    [self.dreamTitleTextField setAppearenceColor:[self appearenceColor]];
    
    selectedFilter = -1;
    
    if (NO) {
        //self.dreamPhotoImageViewAspectEmpty.active = YES;
        //self.dreamPhotoImageViewAspectLoaded.active = NO;
    }
    
    dummyImageName = [self appearenceStyle] == AppearenceStyleGREEN
    ? @"dummy-green" : ([self appearenceStyle] == AppearenceStylePURPLE
                        ? @"dummy-purple" : @"dummy-blue");
    self.dreamPhotoImageView.image = [UIImage imageNamed:dummyImageName];
    self.addDreamBtn.backgroundColor = [self appearenceColor];
    
    NSString *photoButtonImageName = [self appearenceStyle] == AppearenceStyleGREEN
    ? @"photo-green" : ([self appearenceStyle] == AppearenceStylePURPLE
                        ? @"photo-purple" : @"photo-blue");
    self.getPhotoButton.image = [UIImage imageNamed:photoButtonImageName];
    self.getPhotoButton.contentMode = UIViewContentModeScaleToFill;
    
    [self updateUIForEdit];
}

- (AppearenceStyle)appearenceStyle {
    BOOL isVip = [Helper profileIsVip];
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return 2;
}

-(BOOL)isSectionRoot {
    return NO;
}

- (void)updateUIForEdit {
    if (self.editedPostId <= 0) {
        self.title = [Helper localizedString:@"_POST_ADD_TITLE"];
        return;
    }
    
    self.title = [Helper localizedString:@"_POST_EDIT_TITLE"];
    
    [self.addDreamBtn setTitle:[[Helper localizedString:@"_POST_EDIT_TITLE"] uppercaseString] forState:UIControlStateNormal];
    
    [self performLoading];
}

- (void)performLoading {
    [ApiDataManager post:self.editedPostId success:^(Post *post_) {
        post = post_;
        [self setupWithPost];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)setupWithPost {
    if (post.owner.id != [Helper profileUserId]) {
        [self showAlert:@"access denied"];
        self.editedPostId = 0;
        return;
    }
    
    self.dreamTitleTextField.text = post.title;
    self.dreamDescTextView.text = post.description_;
    [self.dreamDescTextView setFocus:false];
    
    [Helper loadImageFrom:post.imageUrl complete:^(NSData *imageData) {
        [self updateWithImage:[UIImage imageWithData:imageData]];
    }];
}

- (void)openPhotoBrowser {
    [self startMediaBrowser:self];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if (CFStringCompare((CFStringRef) mediaType, kUTTypeImage, 0) == kCFCompareEqualTo) {
        editedImage = (UIImage *)[info objectForKey:UIImagePickerControllerEditedImage];
        originalImage = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
        
        [self startImageCrop:imageToUse];
    }
    
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)startImageCrop:(UIImage *)image {
    ImageCropViewController *controller = [[ImageCropViewController alloc] initWithImage:image];
    controller.delegate = self;
    controller.ratio = POST_IMAGE_RATIO;
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [self updateWithImage:croppedImage];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)updateWithImage:(UIImage *)image {
    selectedFilter = -1;
    
    if (image) {
        UIImage *imageFixedOrientation = [UIHelpers fixOrientation:image];
        image = imageFixedOrientation;
        
        currentPickedImage = image;
        
        CGSize viewSize = self.dreamPhotoImageView.frame.size;
        UIImage *imageFit = [image imageToFitSize:viewSize method:IFResizeCrop];
        currentPickedImageScaled = imageFit;
        
        [self setupAppear];
    }
    else {
        currentPickedImage = nil;
        currentPickedImageScaled = nil;
        
        [self setupDisappear];
    }
    
    [self updateMainImageViewWithFilter:-1];
}

- (void)updateMainImageViewWithFilter:(NSInteger)filter {
    if (currentPickedImageScaled) {
        [self updateImageViewWithFilter:self.dreamPhotoImageView imageSource:currentPickedImageScaled filter:filter];
    }
    else {
        // ставим исходную
        self.dreamPhotoImageView.image = [UIImage imageNamed:dummyImageName];
        self.dreamPhotoImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

- (void)updateImageViewWithFilter:(UIImageView *)imageView imageSource:(UIImage *)imageSource filter:(NSInteger)filter {
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *image = imageView.image;
    [self applyFilter:&image imageSource:imageSource filter:filter];
    imageView.image = image;
}

- (void)applyFilter:(UIImage **)toImage imageSource:(UIImage *)imageSource filter:(NSInteger)filter {
    //dispatch_async(dispatch_get_main_queue(), ^{
    switch (filter) {
        case 0:
            *toImage = [imageSource blackAndWhite];
            break;
            
        case 1:
            *toImage = [imageSource sepia];
            break;
            
        case 2:
            *toImage = [imageSource vibrant:1];
            break;
            
        case 3:
            *toImage = [imageSource erode];
            break;
            
        default:
            *toImage = imageSource;
            break;
    }
    //});
}

- (void)setupAppear {
    int totalFilters = 4;
    CGFloat containerWidth = self.filtersContainerView.frame.size.width;
    CGFloat padding = 12;
    CGFloat filterImageWidth = (containerWidth - (padding * (totalFilters - 1))) / totalFilters;
    
    self.filtersView.hidden = NO;
    self.filtersView.alpha = 0.1f;
    self.filtersViewHeight.constant = filterImageWidth + 42; // 42 - label+constraint, 6 - borders
    
    //self.dreamPhotoImageViewAspectEmpty.active = NO;
    //self.dreamPhotoImageViewAspectLoaded.active = YES;
    
    [self.contentView setNeedsLayout];
    [UIView animateWithDuration:0.9 animations:^{
        [self.contentView layoutIfNeeded];
        self.filtersView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        //[self fitContentView];
        [self.contentView layoutIfNeeded];
        self.scrollView.contentSize = self.contentView.bounds.size;
    }];
    
    [[self.filtersContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGSize filterImageSize = CGSizeMake(filterImageWidth, filterImageWidth);
    UIImage *imageFilterScaled = [currentPickedImage imageToFitSize:filterImageSize method:IFResizeCrop];
    
    for (int i = 0; i < totalFilters; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CGRect rect = CGRectMake(i * (filterImageWidth + (i > 0 ? padding : 0)), 0, filterImageWidth, filterImageWidth);
            [self addFilterImageAtIndex:imageFilterScaled index:i rect:rect];
        });
    }
}

- (void)setupDisappear {
    self.filtersView.hidden = NO;
    self.filtersView.alpha = 1.0f;
    self.filtersViewHeight.constant = 0;
    
    //self.dreamPhotoImageViewAspectEmpty.active = YES;
    //self.dreamPhotoImageViewAspectLoaded.active = NO;
    
    [self.contentView setNeedsLayout];
    [UIView animateWithDuration:0.9 animations:^{
        [self.contentView layoutIfNeeded];
        self.filtersView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [[self.filtersContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        //[self fitContentView];
        [self.contentView layoutIfNeeded];
        self.scrollView.contentSize = self.contentView.bounds.size;
    }];
}

- (void)addFilterImageAtIndex:(UIImage *)image index:(NSInteger)index rect:(CGRect)rect {
    UIImageView *imageView =[[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.tag = index;
    
    [self setFilterImageBorderLayer:imageView selected:NO];
    
    [self.filtersContainerView addSubview:imageView];
    
    UITapGestureRecognizer *selectFilter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filterTouch:)];
    [imageView addGestureRecognizer:selectFilter];
    
    [self updateImageViewWithFilter:imageView imageSource:image filter:index];
}

- (void)setFilterImageBorderLayer:(UIImageView *)imageView selected:(bool)selected {
    [imageView.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CALayer *borderLayer = [CALayer layer];
    if (selected) {
        CGRect borderFrame2 = CGRectMake(-6, -6, (imageView.frame.size.width + 12), (imageView.frame.size.height + 12));
        [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [borderLayer setFrame:borderFrame2];
        [borderLayer setCornerRadius:2.0];
        [borderLayer setBorderWidth:3.0];
        [borderLayer setBorderColor:[[UIColor colorWithRed:0.247 green:0.317 blue:0.710 alpha:1] CGColor]];
    }
    else {
        CGRect borderFrame = CGRectMake(0, 0, (imageView.frame.size.width), (imageView.frame.size.height));
        [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
        [borderLayer setFrame:borderFrame];
        [borderLayer setCornerRadius:0.0];
        [borderLayer setBorderWidth:3.0];
        [borderLayer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        [borderLayer setShadowOffset:CGSizeMake(0, 0)];
        [borderLayer setShadowColor:[[UIColor blackColor] CGColor]];
        [borderLayer setShadowOpacity:0.4];
        [borderLayer setShadowRadius:1.8];
    }
    [imageView.layer addSublayer:borderLayer];
}

- (void)filterTouch:(UITapGestureRecognizer *)gr {
    UIImageView *selectedImageView = (UIImageView *)gr.view;
    if (selectedFilter == selectedImageView.tag) {
        // сброс фильтра
        selectedFilter = -1;
        [self updateMainImageViewWithFilter:-1];
        [self setFilterImageBorderLayer:selectedImageView selected:NO];
        return;
    }
    
    if ([self.filtersContainerView.subviews count] > selectedFilter && selectedFilter >= 0) {
        UIImageView *previousFilterImageView = [self.filtersContainerView.subviews objectAtIndex:selectedFilter];
        if (previousFilterImageView) {
            // снять выделение
            [self setFilterImageBorderLayer:previousFilterImageView selected:NO];
        }
    }
    
    selectedFilter = selectedImageView.tag;
    [self setFilterImageBorderLayer:selectedImageView selected:YES];
    
    [self updateMainImageViewWithFilter:selectedFilter];
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (self.dreamTitleTextField == theTextField && [self validateDreamTitle]) {
        [self.dreamDescTextView becomeFirstResponder];
    }
    return [super textFieldShouldReturn:theTextField];
}

- (BOOL)validateImage {
    if (currentPickedImage == nil) {
        [self showNotification:@"_POST_ADD_IMAGE_NO"];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)validateDreamTitle {
    NSString *msg;
    if (![self.dreamTitleTextField checkConstraints:&msg]) {
        [self showNotification:msg];
        return NO;
    }
    return YES;
}

- (BOOL)validateDreamDescr {
    if (![self.dreamDescTextView checkConstraints]) {
        [self showNotification:@"_POST_ADD_DESCR_NO"];
        return NO;
    }
    return YES;
}

- (IBAction)addDreamTouch:(id)sender {
    if (!([self validateImage] && [self validateDreamTitle] && [self validateDreamDescr])) {
        return;
    }
    
    UIImage *image = currentPickedImage;
    if (image) {
        UIImage *pickedImageWithFilter;
        [self applyFilter:&pickedImageWithFilter imageSource:image filter:selectedFilter];
        image = pickedImageWithFilter;
        
        image = [Helper resizeImageToMaxDimension:image dimension:1024];
    }
    
    [self.view endEditing:YES];
    self.addDreamBtn.enabled = NO;
    
    if (self.editedPostId > 0) {
        UIAlertController *alert = [self showPendingAlert:[Helper localizedStringIfIsCode:@"_POST_EDIT_PENDING_T"] message:nil];
        
        [ApiDataManager updatepost:self.editedPostId
                              name:self.dreamTitleTextField.text
                       description:self.dreamDescTextView.text
                             image:image success:^(void) {
                                 self.addDreamBtn.enabled = YES;
                                 [alert dismissViewControllerAnimated:YES completion:^{
                                     [self showAlert:NSLocalizedString(@"_POST_EDIT_SUCCESS", @"")];
                                 }];
                                 [self performLoading];
                                 [Helper clearImageForUrl:post.imageUrl];
                                 [Helper setNeedsUpdate:YES];
                             } error:^(NSString *error) {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                                 [self showAlert:error];
                                 self.addDreamBtn.enabled = YES;
                             }];
    }
    else {
        UIAlertController *alert = [self showPendingAlert:[Helper localizedStringIfIsCode:@"_POST_ADD_PENDING_T"] message:nil];
        
        [ApiDataManager addpost:self.dreamTitleTextField.text
                    description:self.dreamDescTextView.text
                          image:image success:^(NSInteger id) {
                              self.addDreamBtn.enabled = YES;
                              [alert dismissViewControllerAnimated:YES completion:^{
                                  [self showAlert:NSLocalizedString(@"_POST_ADD_SUCCESS", @"")];
                                  [self updateWithImage:nil];
                                  [self.tabsDelegate needUpdateTabs:self];
                              }];
                              
                              [self clearInputs];
                          } error:^(NSString *error) {
                              [alert dismissViewControllerAnimated:YES completion:nil];
                              [self showAlert:error];
                              self.addDreamBtn.enabled = YES;
                          }];
    }
}

+ (void)beginImageContextWithSize:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
}

+ (void)endImageContext {
    UIGraphicsEndImageContext();
}

- (IBAction)cancelTouch:(id)sender {
    if (self.editedPostId > 0) {
        [self setupWithPost];
    }
    else {
        [self clearInputs];
        [self updateWithImage:nil];
    }
}

- (void)clearInputs {
    self.dreamTitleTextField.text = nil;
    [self.dreamTitleTextField onchange:nil];
    self.dreamDescTextView.text = nil;
    [self.dreamDescTextView setFocus:false];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if (self.scrollView) {
        NSDictionary *info = [notification userInfo];
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        kbRect = [self.view convertRect:kbRect fromView:nil];
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        [self performSelector:@selector(moveToBottom) withObject:nil afterDelay:0.1];
    }
}

- (void)moveToBottom {
    CGRect target = CGRectMake(0, self.contentView.frame.size.height, 1, 1);
    [self.scrollView scrollRectToVisible:target animated:YES];
}

@end