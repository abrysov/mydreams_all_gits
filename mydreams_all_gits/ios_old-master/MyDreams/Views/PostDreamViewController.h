//
//  AddDreamViewController.h
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonTextField.h"
#import "BorderedButton.h"
#import "CommonLabel.h"
#import "CommonTextView.h"
#import "ImageCropView.h"
#import "MDSwitch.h"


@interface PostDreamViewController : BaseViewController<ImageCropViewControllerDelegate>

@property (assign, nonatomic) NSInteger editedDreamId;

@property (weak, nonatomic) IBOutlet UIImageView *dreamPhotoImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dreamPhotoImageViewAspectLoaded;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dreamPhotoImageViewAspectEmpty;
@property (weak, nonatomic) IBOutlet UIImageView *getPhotoButton;
@property (weak, nonatomic) IBOutlet UIView *filtersContainerView;
@property (weak, nonatomic) IBOutlet UIView *filtersView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filtersViewHeight;

@property (weak, nonatomic) IBOutlet CommonTextField *dreamTitleTextField;
@property (weak, nonatomic) IBOutlet CommonTextView *dreamDescTextView;
@property (weak, nonatomic) IBOutlet CommonLabel *dreamDescTextViewLabel;
@property (weak, nonatomic) IBOutlet UIView *dreamDescTextViewBorder;
@property (weak, nonatomic) IBOutlet MDSwitch *doneSwitch;
@property (weak, nonatomic) IBOutlet CommonLabel *doneLabel;

@property (weak, nonatomic) IBOutlet BorderedButton *addDreamBtn;
@property (weak, nonatomic) IBOutlet BorderedButton *cancelBtn;

- (IBAction)addDreamTouch:(id)sender;
- (IBAction)cancelTouch:(id)sender;

@end
