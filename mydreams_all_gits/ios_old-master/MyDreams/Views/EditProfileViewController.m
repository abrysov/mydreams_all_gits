//
//  EditProfileViewController.m
//  MyDreams
//
//  Created by Игорь on 15.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UIImageView+WebCache.h"
#import "EditProfileViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import <ImageFilters/ImageFilter.h>
#import "Helper.h"
#import "Constants.h"
#import "Location.h"
#import "LocationSelectViewController.h"
#import "ApiDataManager.h"
#import "Flybook.h"
#import "ImageCropView.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController {
    Flybook *flybook;
    Location *selectedLocation;
    BOOL avatarChanged;
    NSInteger imageSelectTarget;
    UIImage *selectedAvatar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupValidation];
    [self setupControls];
    
    [self performLoading];
    
    //self.saveButton.enabled = NO;
    self.title = [Helper localizedString:@"_PROFILE_EDIT"];
    
    self.saveButton.backgroundColor = [Helper profileIsVip] ? [Helper colorWithHexString:COLOR_STYLE_PURPLE] : [Helper colorWithHexString:COLOR_STYLE_BLUE];
    [self.photoButton setBackgroundImage:[UIImage imageNamed:[Helper profileIsVip] ? @"photo-purple" : @"photo-blue"] forState:UIControlStateNormal];
}

- (AppearenceStyle)appearenceStyle {
    return [Helper profileIsVip] ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return 2;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self fitContentView];
}

- (void)setupControls {
    [self.nameTextField setLabel:self.nameLabel];
    [self.surnameTextField setLabel:self.surnameLabel];
    [self.emailTextField setLabel:self.emailLabel];
    [self.phoneTextField setLabel:self.phoneLabel];
    [self.passwordTextField setLabel:self.passwordLabel];
    [self.repeatTextField setLabel:self.repeatLabel];
    [self.passwordOldTextField setLabel:self.passwordOldLabel];
    [self.locationTextField setLabel:self.locationLabel];    
    
    UIColor *appearenceColor = [self appearenceColor];
    [self.nameTextField setAppearenceColor:appearenceColor];
    [self.surnameTextField setAppearenceColor:appearenceColor];
    [self.emailTextField setAppearenceColor:appearenceColor];
    [self.phoneTextField setAppearenceColor:appearenceColor];
    [self.passwordTextField setAppearenceColor:appearenceColor];
    [self.repeatTextField setAppearenceColor:appearenceColor];
    [self.repeatTextField setAppearenceColor:appearenceColor];
    [self.passwordOldTextField setAppearenceColor:appearenceColor];
    [self.locationTextField setAppearenceColor:appearenceColor];
    
    AppearenceStyle appearence = [self appearenceStyle];
    if (AppearenceStylePURPLE == appearence) {
        self.mailIconImage.image = [UIImage imageNamed:YES ? @"email-purple" : @"email-blue"];
        self.markerIconImage.image = [UIImage imageNamed:YES ? @"map-marker-purple" : @"map-marker-blue"];
        self.userIconImage.image = [UIImage imageNamed:YES ? @"account-purple" : @"account-blue"];
        self.phoneIconImage.image = [UIImage imageNamed:YES ? @"phone-purple" : @"phone-blue"];
        self.lockIconImage.image = [UIImage imageNamed:YES ? @"lock-purple" : @"lock-blue"];
    }
}

- (void)setupValidation {
    self.nameTextField.required = YES;
    self.nameTextField.requiredMsg = [Helper localizedString:@"_SIGNUP_NAME_NO"];
    self.nameTextField.minimum = 3;
    self.nameTextField.maximum = 20;
    self.nameTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_NAME_LIMITS"];
    
    self.surnameTextField.minimum = 3;
    self.surnameTextField.maximum = 20;
    self.surnameTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_SURNAME_LIMITS"];
    
    self.emailTextField.required = YES;
    self.emailTextField.requiredMsg = [Helper localizedString:@"_SIGNUP_EMAIL_NO"];
    self.emailTextField.pattern = EMAIL_REGEX_PATTERN;
    self.emailTextField.patternMsg = [Helper localizedString:@"_SIGNUP_EMAIL_MATCH"];
    self.emailTextField.minimum = 1;
    self.emailTextField.maximum = 70;
    self.emailTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_EMAIL_MATCH"];
    
    self.phoneTextField.minimum = 9;
    self.phoneTextField.maximum = 14;
    self.phoneTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_PHONE_MATCH"];
    self.phoneTextField.pattern = PHONE_REGEX_PATTERN;
    self.phoneTextField.patternMsg = [Helper localizedString:@"_SIGNUP_PHONE_MATCH"];
    
    self.passwordTextField.requiredMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_NO"];
    self.passwordTextField.pattern = PASSWORD_REGEX_PATTERN;
    self.passwordTextField.patternMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_MATCH"];
    self.passwordTextField.minimum = 5;
    self.passwordTextField.maximum = 20;
    self.passwordTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_LIMITS"];
}

- (void)performLoading {
    [ApiDataManager flybook:0 success:^(Flybook *flybook_) {
        flybook = flybook_;
        [self initUI];
        [Helper updateProfile:flybook_];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)initUI {
    self.nameTextField.text = flybook.name;
    self.surnameTextField.text = flybook.surname;
    self.emailTextField.text = flybook.email;
    self.phoneTextField.text = flybook.phone;
    self.locationTextField.text = flybook.location;
    
    [self.nameTextField triggerchange];
    [self.surnameTextField triggerchange];
    [self.emailTextField triggerchange];
    [self.phoneTextField triggerchange];
    [self.locationTextField triggerchange];
    
    [self updateImageView:flybook.avatarUrl];
}

- (void)updateImageView:(NSString *)imageUrl {
    [Helper setImageView:self.avatarImageView withImageUrl:imageUrl andDefault:([Helper profileIsVip] ? @"dummy-purple" : @"dummy-blue")];
}

- (BOOL)validateTextField:(CommonTextField *)textField {
    NSString *msg;
    if (![textField checkConstraints:&msg]) {
        [self showNotification:msg];
        return NO;
    }
    return YES;
}

- (BOOL)validateName {
    return [self validateTextField:self.nameTextField];
}

- (BOOL)validateSurname {
    return [self validateTextField:self.surnameTextField];
}

- (BOOL)validateEmail {
    return [self validateTextField:self.emailTextField];
}

- (BOOL)validatePhone {
    return [self validateTextField:self.phoneTextField];
}

- (BOOL)validatePassword {
    return [self validateTextField:self.passwordTextField];
}

- (BOOL)validateRepeat {
    if ([self.passwordTextField.text length] == 0) {
        return YES;
    }
    if ([self.passwordTextField.text isEqualToString:self.repeatTextField.text]) {
        return YES;
    }
    else {
        [self showNotification:@"_SIGNUP_REPEAT_MATCH"];
        return NO;
    }
}

- (BOOL)validateOldPassword {
    if ([self.passwordTextField.text length] == 0) {
        return YES;
    }
    if ([self.passwordOldTextField.text length] == 0) {
        [self showNotification:@"_PROFILE_OLDPASSWORD_NO"];
        return NO;
    }
    return YES;
}

- (BOOL)validateLocation {
    return YES;
}

- (BOOL)validate {
    return [self validateName]
    && [self validateSurname]
    && [self validateEmail]
    && [self validatePhone]
    && [self validatePassword]
    && [self validateRepeat]
    && [self validateOldPassword]
    && [self validateLocation];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.nameTextField == textField && [self validateName]) {
        [self.surnameTextField becomeFirstResponder];
    }
    else if (self.surnameTextField == textField && [self validateSurname]) {
        [self.emailTextField becomeFirstResponder];
    }
    else if (self.emailTextField == textField && [self validateEmail]) {
        [self.phoneTextField becomeFirstResponder];
    }
    else if (self.phoneTextField == textField && [self validatePhone]) {
        [self.locationTextField becomeFirstResponder];
    }
    else if (self.passwordTextField == textField && [self validatePassword]) {
        [self.repeatTextField becomeFirstResponder];
    }
    else if (self.repeatTextField == textField && [self validateRepeat]) {
        [self.passwordOldTextField becomeFirstResponder];
    }
    return [super textFieldShouldReturn:textField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.locationTextField == textField) {
        [self.view endEditing:YES];
        [self locationBeginSelect];
    }
    [super textFieldDidBeginEditing:textField];
}

- (void)locationBeginSelect {
    LocationSelectViewController *locationController = [[LocationSelectViewController alloc] initWithNibName:@"LocationSelectViewController" bundle:nil];
    //locationController.transitioningDelegate = self;
    locationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    locationController.modalPresentationStyle = UIModalPresentationCustom;
    locationController.selectedLocation = selectedLocation;
    locationController.delegate = self;
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7)
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:locationController animated:YES completion:nil];
}

- (void)didLocationSelect:(Location *)location {
    [self updateLocation:location];
    [self.locationTextField resignFirstResponder];
}

- (void)didLocationSelectCancel {
    [self.locationTextField resignFirstResponder];
}

- (void)updateLocation:(Location *)location {
    selectedLocation = location;
    self.locationTextField.text = location.name;
    [self.locationTextField onchange:self.locationTextField.text];
}

- (NSDictionary *)collectChanges {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (![flybook.name isEqualToString:self.nameTextField.text]) {
        [params setObject:self.nameTextField.text forKey:@"name"];
    }
    if (![flybook.surname isEqualToString:self.surnameTextField.text]) {
        [params setObject:self.surnameTextField.text forKey:@"surname"];
    }
    if (![flybook.email isEqualToString:self.emailTextField.text]) {
        [params setObject:self.emailTextField.text forKey:@"email"];
    }
    if (![flybook.phone isEqualToString:self.phoneTextField.text]) {
        [params setObject:self.phoneTextField.text forKey:@"phone"];
    }
    if (flybook.locationId != selectedLocation.id && selectedLocation.id > 0) {
        [params setObject:[NSNumber numberWithLong:selectedLocation.id] forKey:@"location"];
    }
    if ([self.passwordTextField.text length] > 0) {
        [params setObject:self.passwordTextField.text forKey:@"password"];
        [params setObject:self.passwordOldTextField.text forKey:@"oldpassword"];
    }
    return params;
}

- (void)save:(NSDictionary *)params {
    if (!selectedAvatar && [params count] <= 0) {
        [self showAlert:@"Нет изменений"];
        return;
    }
    
    BOOL updateAvatar = selectedAvatar != nil;
    BOOL updateProfile = [params count] > 0;
    
    BOOL __block updateAvatarComplete = !updateAvatar;
    BOOL __block updateProfileComplete = !updateProfile;
    
    if (updateAvatar) {
        UIImage *avatarImage = [Helper resizeImageToMaxDimension:selectedAvatar dimension:1024];
        [ApiDataManager uploadavatar:avatarImage success:^(NSString *avatarUrl) {
            updateAvatarComplete = YES;
            [Helper clearImageForUrl:avatarUrl];
            [Helper clearImageForUrl:flybook.avatarUrl];
            
            if (updateProfileComplete) {
                [self showAlert:@"Данные сохранены"];
                [self performLoading];
                [self.tabsDelegate needUpdateTabs:self];
            }
            selectedAvatar = nil;
        } error:^(NSString *error) {
            updateAvatarComplete = YES;
            [self showAlert:@"Не удалось загрузить аватар"];
        }];
    }
    
    if (updateProfile) {
        [ApiDataManager profileupdate:params success:^(NSString *message) {
            updateProfileComplete = YES;
            
            if (updateAvatarComplete) {
                [self showAlert:@"Данные сохранены"];
                [self performLoading];
                [self.tabsDelegate needUpdateTabs:self];
            }
        } error:^(NSString *error) {
            updateProfileComplete = YES;
            [self showAlert:error];
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 6743:
        {
            switch (buttonIndex) {
                case 1:
                    [self save:[self collectChanges]];
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            [super alertView:alertView clickedButtonAtIndex:buttonIndex];
            break;
    }
}

- (IBAction)selectAvatarTouch:(id)sender {
    imageSelectTarget = 1;
    [self startMediaBrowser:self];
}

- (IBAction)saveTouch:(id)sender {
    if (![self validate]) {
        return;
    }
    
    if (!selectedAvatar && [[self collectChanges] count] <= 0) {
        [self showAlert:@"Нет изменений"];
        return;
    }
    
//    if ([params count] == 0) {
//        return;
//    }
    
    UIAlertView *alert = [self showConfirmationDialog:@"_PROFILE_SAVE_CONFIRM" delegate:self];
    alert.tag = 6743; // magic number!
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
    switch (imageSelectTarget) {
        case 1:
            [self updateAvatar:croppedImage];
            break;
            
//        case 2:
//            [self selectedNewPhoto:croppedImage];
//            break;
    }
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)ImageCropViewControllerDidCancel:(ImageCropViewController *)controller {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)updateAvatar:(UIImage *)image {
    self.avatarImageView.image = image;
    selectedAvatar = image;
}

@end
