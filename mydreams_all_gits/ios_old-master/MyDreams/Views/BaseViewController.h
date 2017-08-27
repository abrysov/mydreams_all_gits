//
//  BaseViewController.h
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"


@protocol TabsRootViewControllerDelegate
- (void)needUpdateTabs:(UIViewController *)sender;
@end

@protocol UpdatableViewControllerDelegate
- (void)update;
@end


@interface BaseViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewHeight;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) UIView *activeField;

- (void)setupContextMenu;
- (NSArray *)setupAlertActions;
- (void)openNavigationMenu;
- (void)logout;
- (BOOL)isSectionRoot;

- (AppearenceStyle)appearenceStyle;
- (void)setupAppearence;
- (UIColor *)appearenceColor;
- (NSInteger)activeMenuItem;

- (void)showAlert:(NSString *)title;
- (void)showAlert:(NSString *)title message:(NSString *)message;

- (UIAlertView *)showConfirmationDialog:(NSString *)title delegate:(id<UIAlertViewDelegate>)delegate;
- (UIAlertView *)showConfirmationDialog:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate;

- (void)showNotification:(NSString *)messageCode;
- (UIAlertController *)showPendingAlert:(NSString *)title message:(NSString *)message;

- (void)placeControl:(UIView *)controlView after:(UIView *)afterView spacing:(CGFloat)verticalSpacing container:(UIView *)containerView;

- (void)fitContainer:(UIView *)containerView;
- (void)fitContentView;
- (void)fitContentViewToScreen;

- (BOOL)startMediaBrowser:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate;

@end
