//
//  EditProfileViewController.h
//  MyDreams
//
//  Created by Игорь on 15.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "BorderedButton.h"
#import "CommonLabel.h"
#import "CommonTextField.h"
#import "LocationSelectViewController.h"
#import "Flybook.h"
#import "ImageCropView.h"

@interface EditProfileViewController : BaseViewController<LocationSelectViewControllerDelegate, ImageCropViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> tabsDelegate;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet CommonTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *surnameTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *repeatTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *passwordOldTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *nameLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *surnameLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *emailLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *phoneLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *passwordLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *repeatLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *passwordOldLabel;
@property (weak, nonatomic) IBOutlet CommonTextField *locationTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UIView *photosView;
//@property (weak, nonatomic) IBOutlet UIView *photosContainerView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIImageView *userIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *mailIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *phoneIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *markerIconImage;
@property (weak, nonatomic) IBOutlet UIImageView *lockIconImage;

- (IBAction)selectAvatarTouch:(id)sender;
- (IBAction)saveTouch:(id)sender;
//- (IBAction)photoCancelTouch:(id)sender;
//- (IBAction)photoDeleteTouch:(id)sender;

@end
