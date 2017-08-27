//
//  ProfilePhotosViewController.h
//  MyDreams
//
//  Created by Игорь on 04.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ImageCropView.h"
#import "MWPhotoBrowser.h"

@interface ProfilePhotosViewController : BaseViewController<ImageCropViewControllerDelegate, MWPhotoBrowserDelegate, UIAlertViewDelegate>

@property (assign, nonatomic) NSInteger userId;

@property (weak, nonatomic) IBOutlet UIView *photosView;
@property (weak, nonatomic) IBOutlet UIView *photosContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photosContainerViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *photoDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *photoCancelDeleteButton;
@property (weak, nonatomic) IBOutlet UIButton *photoSaveButton;
@property (weak, nonatomic) IBOutlet UIButton *photoCancelSaveButton;

- (IBAction)photoCancelTouch:(id)sender;
- (IBAction)photoDeleteTouch:(id)sender;
- (IBAction)photoSaveTouch:(id)sender;

@end
