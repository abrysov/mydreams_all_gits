//
//  PostPostViewController.h
//  MyDreams
//
//  Created by Игорь on 09.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonTextField.h"
#import "BorderedButton.h"
#import "CommonLabel.h"
#import "CommonTextView.h"
#import "ImageCropView.h"


@interface PostPostViewController : BaseViewController<ImageCropViewControllerDelegate>

@property (assign, nonatomic) NSInteger editedPostId;

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> tabsDelegate;

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

@property (weak, nonatomic) IBOutlet BorderedButton *addDreamBtn;
@property (weak, nonatomic) IBOutlet BorderedButton *cancelBtn;

- (IBAction)addDreamTouch:(id)sender;
- (IBAction)cancelTouch:(id)sender;

@end
