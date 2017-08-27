//
//  ProfilePhotosViewController.m
//  MyDreams
//
//  Created by Игорь on 04.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "EditProfileViewController.h"
#import "MWPhotoBrowser.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageFilters/ImageFilter.h>
#import "ProfilePhotosViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"

@interface ProfilePhotosViewController ()

@end

@implementation ProfilePhotosViewController {
    Flybook *flybook;
    NSMutableArray *checkedPhotos;
    NSMutableArray *newPhotos;
    BOOL isEditMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [self isSelf] ? [Helper localizedString:@"_PROFILE_PHOTOS"] : @"Фото";
    
    if ([self isSelf]) {
        [self setupContextMenu];
    }
    [self performLoading];
}

- (AppearenceStyle)appearenceStyle {
    return [self isSelf]
        ? ([Helper profileIsVip] ? AppearenceStylePURPLE : AppearenceStyleBLUE)
        : (flybook && flybook.isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE);
}

- (NSInteger)activeMenuItem {
    return 2;
}

- (BOOL)isSelf {
    return self.userId == 0 || [Helper profileUserId] == self.userId;
}

- (NSArray *)setupAlertActions {
    if (![self isSelf]) {
        return nil;
    }
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Добавить фото"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self addPhoto];
    }];
    [alertActions addObject:addAction];
    
    UIAlertAction *editAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Удалить фото"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self startEdit];
    }];
    [alertActions addObject:editAction];
   
    return alertActions;
}

- (void)toggleButtons {
    if (![self isSelf]) {
        self.photoDeleteButton.hidden = YES;
        self.photoCancelDeleteButton.hidden = YES;
        self.photoSaveButton.hidden = YES;
        self.photoCancelSaveButton.hidden = YES;
    }
    
    self.photoDeleteButton.hidden = !isEditMode;
    self.photoCancelDeleteButton.hidden = !isEditMode ;
    self.photoSaveButton.hidden = isEditMode || [newPhotos count] == 0;
    self.photoCancelSaveButton.hidden = isEditMode || [newPhotos count] == 0;
}

- (void)performLoading {
    [ApiDataManager flybook:self.userId success:^(Flybook *flybook_) {
        flybook = flybook_;
        [self initUI];
        [self setupAppearence];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)initUI {
    [self setupPhotos];
}

- (void)startEdit {
    isEditMode = YES;
    [self setupPhotos];
}

- (void)addPhoto {
    [self startMediaBrowser:self];
}

- (NSArray *)collectPhotos {
    NSMutableArray *allPhotos = [[NSMutableArray alloc] initWithArray:flybook.photos];
    [allPhotos addObjectsFromArray:newPhotos];
    return allPhotos;
}

- (void)setupPhotos {
    [[self.photosContainerView subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSArray *photos = [self collectPhotos];
    NSInteger totalPhotos = [photos count];
    NSInteger photosPerRow = 3;
    CGFloat padding = 20;
    CGFloat containerWidth = self.photosContainerView.frame.size.width;
    CGFloat onePhotoCellWidth = (containerWidth - (photosPerRow - 1) * padding) / photosPerRow;
    
    for (int i = 0; i < totalPhotos; i++) {
        NSInteger rowNumber = i / photosPerRow;
        NSInteger cellNumber = i % photosPerRow;
        CGRect frame = CGRectMake(cellNumber * (onePhotoCellWidth + padding), rowNumber * (onePhotoCellWidth + padding), onePhotoCellWidth, onePhotoCellWidth);
        /*if (i == totalPhotos - 1) {
            // фотка с иконкой
            //[self insertPlusPhoto:frame];
        }
        else*/ {
            id photo = [photos objectAtIndex:i];
            if ([photo isKindOfClass:[FlybookPhoto class]]) {
                [self insertUserPhoto:photo rect:frame];
            }
            else if ([photo isKindOfClass:[UIImage class]]) {
                [self insertNewPhoto:photo rect:frame index:i];
            }
        }
    }
    
    NSInteger totalRows = ceil((float)totalPhotos / photosPerRow);
    self.photosContainerViewHeight.constant = totalRows * (onePhotoCellWidth + padding);
    [self toggleButtons];
    [self.view layoutIfNeeded];
}

//- (void)insertPlusPhoto:(CGRect)rect {
//    UIButton *button = [[UIButton alloc] initWithFrame:rect];
//    [button setBackgroundImage: [UIImage imageNamed:@"add_photo.png"] forState:UIControlStateNormal];
//    button.alpha = 0.8;
//    [button addTarget:self action:@selector(addPhoto:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.photosContainerView addSubview:button];
//}

- (void)insertUserPhoto:(FlybookPhoto *)photo rect:(CGRect)rect {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.tag = photo.id;
    imageView.clipsToBounds = YES;
    
    [Helper setImageView:imageView withImageUrl:photo.url andDefault:@"_LOGO_IMAGE_BLUE"];
    
    [self insertPhoto:imageView];
}

- (void)insertNewPhoto:(UIImage *)photo rect:(CGRect)rect index:(NSUInteger)index {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    // для новых фоток отрицательный порядковый номер, чтобы отличать от id
    imageView.tag = -index;
    imageView.image = photo;
    imageView.clipsToBounds = YES;
    
    [self insertPhoto:imageView];
}

- (void)insertPhoto:(UIImageView *)imageView {
    [self.photosContainerView addSubview:imageView];
    [self setCheckedState:imageView];
    
    UITapGestureRecognizer *selectFilter = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onPhotoTouch:)];
    [imageView addGestureRecognizer:selectFilter];
}

- (void)selectedNewPhoto:(UIImage *)photo {
    if (!newPhotos) {
        newPhotos = [[NSMutableArray alloc] init];
    }
    checkedPhotos = nil;
    isEditMode = NO;
    [newPhotos addObject:photo];
    [self setupPhotos];
}

- (void)onPhotoTouch:(UITapGestureRecognizer *)gr {
    if (isEditMode) {
        [self togglePhoto:(UIImageView *)gr.view];
    }
    else {
        [self startGallery:(UIImageView *)gr.view];
    }
}

- (void)togglePhoto:(UIImageView *)imageView {
    if (!checkedPhotos) {
        checkedPhotos = [[NSMutableArray alloc] init];
    }
    
    NSNumber *photoId = [NSNumber numberWithLong:imageView.tag];
    if ([checkedPhotos containsObject:photoId]) {
        [checkedPhotos removeObject:photoId];
    }
    else {
        [checkedPhotos addObject:photoId];
    }
    
    [self setCheckedState:imageView];
    
    [self updateDeleteButtonTitle];
}

- (void)setCheckedState:(UIImageView *)imageView {
    NSNumber *photoId = [NSNumber numberWithLong:imageView.tag];
    if ([checkedPhotos containsObject:photoId]) {
        
        CGRect sheetFrame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
        UIView *sheetView = [[UIView alloc] initWithFrame:sheetFrame];
        sheetView.backgroundColor = [UIColor blackColor];
        sheetView.alpha = 0.4;
        [imageView addSubview:sheetView];
        
        CGRect iconFrame = CGRectMake(imageView.frame.size.width / 2 - 15, imageView.frame.size.height / 2 - 15, 30, 30);
        UIImageView *deleteIcon = [[UIImageView alloc] initWithFrame:iconFrame];
        deleteIcon.image = [UIImage imageNamed:@"window-close-2"];
        deleteIcon.contentMode = UIViewContentModeScaleAspectFit;
        [imageView addSubview:deleteIcon];
    }
    else {
        [[imageView subviews ] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
}

- (void)updateDeleteButtonTitle {
    if ([checkedPhotos count] > 0) {
    [self.photoDeleteButton setTitle:[[NSString stringWithFormat:@"%@ (%ld)", [Helper localizedString:@"_PHOTO_DELETE"], [checkedPhotos count]] uppercaseString] forState:UIControlStateNormal];
    }
    else {
        [self.photoDeleteButton setTitle:[[Helper localizedString:@"_PHOTO_DELETE"] uppercaseString] forState:UIControlStateNormal];
    }
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
    controller.cropView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    controller.delegate = self;
    [[self navigationController] pushViewController:controller animated:YES];
}

- (void)ImageCropViewController:(ImageCropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage {
    [self selectedNewPhoto:croppedImage];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)startGallery:(UIImageView *)imageView {
    NSLog(@"START");
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    
    NSInteger startPhotoIndex = 0;
    if (imageView.tag > 0) {
        for (int i = 0; i < [flybook.photos count]; i++) {
            FlybookPhoto *photo = flybook.photos[i];
            if (photo.id == imageView.tag) {
                startPhotoIndex = i;
                break;
            }
        }
    }
    else {
        // в этом случае imageView.tag - отрицательный порядковый номер в массиве newPhotos
        startPhotoIndex = [flybook.photos count] + (-imageView.tag) - 1;
    }
    
    [browser setCurrentPhotoIndex:startPhotoIndex];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [[self collectPhotos] count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    NSArray *photos = [self collectMWPhotos];
    if (index < photos.count) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

- (NSArray *)collectMWPhotos {
    NSArray *photos = [self collectPhotos];
    
    NSMutableArray *mwPhotos = [NSMutableArray array];
    
    for (id photo in photos) {
        if ([photo isKindOfClass:[FlybookPhoto class]]) {
            NSString *imageUrl = ((FlybookPhoto *)photo).url;
            NSString *fullUrl = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
                ? imageUrl
                : [NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl];
            [mwPhotos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:fullUrl]]];
        }
        else if ([photo isKindOfClass:[UIImage class]]) {
            [mwPhotos addObject:[MWPhoto photoWithImage:(UIImage *)photo]];
        }
    }
    
    return mwPhotos;
}

- (IBAction)photoCancelTouch:(id)sender {
    if (isEditMode) {
        //newPhotos = nil;
        checkedPhotos = nil;
        isEditMode = NO;
        [self updateDeleteButtonTitle];
    }
    else {
        newPhotos = nil;
    }
    
    [self setupPhotos];
}

- (IBAction)photoDeleteTouch:(id)sender {
    if (![self anythingToSave2]) {
        [self showAlert:@"Нет изменений"];
        return;
    }
    
    BOOL anyNewDeleted = NO;
    for (NSNumber *i in [NSArray arrayWithArray:checkedPhotos]) {
        if ([i longValue] <= 0) {
            // убрать новую несохраненную фотку
            NSUInteger index = -[i longValue] - [flybook.photos count];
            [newPhotos removeObjectAtIndex:index];
            [checkedPhotos removeObject:i];
            anyNewDeleted = YES;
        }
    }
    
    if ([checkedPhotos count] <= 0) {
        if (anyNewDeleted) {
            [self updateDeleteButtonTitle];
        }
        return;
    }
    
    UIAlertController *pending = [self showPendingAlert:[Helper localizedStringIfIsCode:@"Обновление..."] message:nil];
    
    [ApiDataManager deletephotos:checkedPhotos success:^{
        checkedPhotos = nil;
        [self updateDeleteButtonTitle];
        
        if (![self anythingToSave2]) {
            [pending dismissViewControllerAnimated:YES completion:^{
                [self showAlert:@"Данные сохранены"];
            }];
            [self performLoading];
        }
    } error:^(NSString *error) {
        if (![self anythingToSave2]) {
            [pending dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (IBAction)photoSaveTouch:(id)sender {
    if (![self anythingToSave1]) {
        [self showAlert:@"Нет изменений"];
        return;
    }
    UIAlertController *pending = [self showPendingAlert:[Helper localizedStringIfIsCode:@"Обновление..."] message:nil];
    
    for (UIImage *image in newPhotos) {
        UIImage *imageToUpload = image;
        UIImage *sizedImage = [Helper resizeImageToMaxDimension:imageToUpload dimension:1024];
        [ApiDataManager uploadphoto:sizedImage success:^(NSInteger photoId, NSString *photoUrl) {
            [newPhotos removeObject:imageToUpload];
            
            if (![self anythingToSave1]) {
                [pending dismissViewControllerAnimated:YES completion:^{
                    [self showAlert:@"Данные сохранены"];
                }];
                
                checkedPhotos = nil;
                [self updateDeleteButtonTitle];

                [self performLoading];
            }
        } error:^(NSString *error) {
            if (![self anythingToSave1]) {
                [pending dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (BOOL)anythingToSave1 {
    if ((newPhotos == nil || [newPhotos count] == 0)
       // && (checkedPhotos == nil || [checkedPhotos count] == 0)
        )
    {
        return NO;
    }
    return YES;
}

- (BOOL)anythingToSave2 {
    if ((checkedPhotos == nil || [checkedPhotos count] == 0))
    {
        return NO;
    }
    return YES;
}

@end
