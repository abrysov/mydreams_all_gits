//
//  BaseViewController.m
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "SlideNavigationController.h"
#import "BaseViewController.h"
#import "CommonTextField.h"
#import "CommonTextView.h"
#import "MDToast.h"
#import "Helper.h"
#import "AppDelegate.h"
#import "PostDreamViewController.h"
#import "EditProfileViewController.h"
#import "FriendsViewController.h"
#import "MenuDialogViewController.h"
#import "MyDreamsNavigationController.h"
#import "SWRevealViewController.h"
#import "Constants.h"

@interface BaseViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation BaseViewController {
    bool keyboardIsShown;
    CGFloat keyboardHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationBar];
    
    [self setupConstraints];
    
    if (self.scrollView) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidShow:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    
    if (self.contentView) {
        UITapGestureRecognizer *tapRec = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
        //[tapRec setCancelsTouchesInView:NO];
        [self.contentView addGestureRecognizer:tapRec];
    }
    
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController && ![self.parentViewController isKindOfClass:[UIPageViewController class]] ) {
        if (!([self conformsToProtocol:@protocol(TabsRootViewControllerDelegate)])) {
            // на экранах с табами выключаем свайп..
            [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        }
        else {
            // ..и добавляем хотябы на шторку
            [revealController.rearViewController.view addGestureRecognizer:revealController.panGestureRecognizer];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    SWRevealViewController *revealController = self.revealViewController;
    if (revealController && ![self.parentViewController isKindOfClass:[UIPageViewController class]] ) {
        // красим в цвета не только при загрузке вью, но и при появлении
        [self setupAppearence];
    }
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStylePURPLE;
}

- (UIColor *)appearenceColor {
    switch ([self appearenceStyle]) {
        case AppearenceStyleBLUE:
            return [Helper colorWithHexString: COLOR_STYLE_BLUE];
            
        case AppearenceStyleDBLUE:
            return [Helper colorWithHexString:  COLOR_STYLE_DBLUE];
            
        case AppearenceStyleGREEN:
            return [Helper colorWithHexString:    COLOR_STYLE_GREEN];
            
        case AppearenceStyleYELLOW:
            return [Helper colorWithHexString:  COLOR_STYLE_YELLOW];
            
        case AppearenceStylePURPLE:
            return [Helper colorWithHexString:  COLOR_STYLE_PURPLE];
            
        case AppearenceStyleRED:
            return [Helper colorWithHexString: COLOR_STYLE_RED];
            
        case AppearenceStyleVIRID:
            return [Helper colorWithHexString: COLOR_STYLE_VIRID];
            
        default:
            return nil;
    }
}

- (NSInteger)activeMenuItem {
    return -1;
}

- (BOOL)isSectionRoot {
    return NO;
}

- (void)setupConstraints {
    if (self.contentView) {
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:0
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:0]];
        
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                              attribute:NSLayoutAttributeRight
                                                              relatedBy:0
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeRight
                                                             multiplier:1.0
                                                               constant:0]];
    }
}

- (void)setupNavigationBar {
    //нужно, чтобы navigation bar не перекрывал контент
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.navigationBar.alpha = 1.0;
    //self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

- (void)setupContextMenu {
    UIBarButtonItem *btnAction = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openNavigationMenu)];
    self.navigationItem.rightBarButtonItems = @[btnAction];
}

- (NSArray *)setupAlertActions {
    return nil;
}

- (void)openNavigationMenu {
    NSArray *alertActions = [self setupAlertActions];
    if (!alertActions) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_CANCEL"] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    for (id alertAction in alertActions) {
        [alertController addAction:alertAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)logout {
    UIAlertView *alert = [self showConfirmationDialog:[Helper localizedString:@"_LOGOUT"] message:[Helper localizedStringIfIsCode:@"_LOGOUT_CONFIRM"] delegate:self];
    alert.tag = 100;
}

- (void)keyboardDidShow:(NSNotification *)notification {
    keyboardIsShown = YES;

    if (self.scrollView) {
        NSDictionary *info = [notification userInfo];
        CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        kbRect = [self.view convertRect:kbRect fromView:nil];
        keyboardHeight = kbRect.size.height;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbRect.size.height, 0.0);
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
        
        //[self.scrollView setContentOffset:CGPointMake(0, kbRect.size.height) animated:NO];
        
        
//        for (UIView *view in self.contentView.subviews) {
//            if (view.isFirstResponder) {
//                self.activeField = (UITextField *)view;
//            }
//        }
//
        if (self.activeField) {
            CGRect aRect = self.view.frame;
            aRect.size.height -= kbRect.size.height;
            
            CGRect absFrame = [self.view convertRect:self.activeField.frame fromView:self.activeField.superview];
            
            CGPoint aPoint = absFrame.origin;
            aPoint.y += absFrame.size.height + 15;

            if (!CGRectContainsPoint(aRect, aPoint)) {
                CGRect target = absFrame;//self.activeField.frame;
                target.origin.y += 15;
                [self.scrollView scrollRectToVisible:target animated:YES];
            }
        }
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification {
    keyboardIsShown = NO;
    
    if (!self.scrollView)
        return;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    //[self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (void)showAlert:(NSString *)title {
    [self showAlert:[Helper localizedStringIfIsCode:title] message:nil];
}

- (void)showAlert:(NSString *)title message: (NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper localizedStringIfIsCode:title]
                                                    message:[Helper localizedStringIfIsCode:message]
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (UIAlertView *)showConfirmationDialog:(NSString *)title delegate: (id<UIAlertViewDelegate>)delegate {
    return [self showConfirmationDialog:[Helper localizedStringIfIsCode:title]
                                message:nil
                               delegate:delegate];
}

- (UIAlertView *)showConfirmationDialog:(NSString *)title message:(NSString *)message delegate:(id<UIAlertViewDelegate>)delegate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Helper localizedStringIfIsCode:title]
                                                    message:[Helper localizedStringIfIsCode:message]
                                                   delegate:delegate
                                          cancelButtonTitle:[Helper localizedString:@"_NO"]
                                          otherButtonTitles:[Helper localizedString:@"_YES"], nil];
    [alert show];
    return alert;
}

- (void)showNotification:(NSString *)message {
    MDToast *toast = [[MDToast alloc] initWithText:[Helper localizedStringIfIsCode:message] duration:1];
    [toast show];
    if (keyboardIsShown) {
        CGRect frame = toast.frame;
        frame.origin.y -= keyboardHeight;
        toast.frame = frame;
    }
}

- (UIAlertController *)showPendingAlert:(NSString *)title message:(NSString *)message {
    if (!message) {
        message = @"\n\n\n";
    }
    
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:[Helper localizedStringIfIsCode:title]
                                            message:[Helper localizedStringIfIsCode:message]
                                     preferredStyle:UIAlertControllerStyleAlert];
    
    //CGRect srcf = alertController.view.frame;
    //CGRect frame = CGRectMake(srcf.origin.x + srcf.size.width / 2.0 - 24.0, srcf.origin.y + 70, 20, 20);
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = CGPointMake(137, 80);
    indicator.color = [UIColor blackColor];
    
    [alertController.view addSubview:indicator];
    indicator.userInteractionEnabled = false;
    [indicator startAnimating];
    
    //    [alertController addAction:[UIAlertAction actionWithTitle:@"Action" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    //        // код обработчика кнопки
    //    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

- (void)placeControl:(UIView *)controlView after:(UIView *)afterView spacing:(CGFloat)verticalSpacing container:(UIView *)containerView {
    NSMutableArray *constraints = [NSMutableArray array];
    
    if (afterView)
        [constraints addObject:[NSLayoutConstraint constraintWithItem:controlView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:afterView
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1.0
                                                             constant:verticalSpacing]];
    else
        [constraints addObject:[NSLayoutConstraint constraintWithItem:controlView
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:containerView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1.0
                                                             constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:controlView
                                                        attribute:NSLayoutAttributeLeading
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:containerView
                                                        attribute:NSLayoutAttributeLeading
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:controlView
                                                        attribute:NSLayoutAttributeTrailing
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:containerView
                                                        attribute:NSLayoutAttributeTrailing
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [constraints addObject:[NSLayoutConstraint constraintWithItem:controlView
                                                        attribute:NSLayoutAttributeWidth
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:containerView
                                                        attribute:NSLayoutAttributeWidth
                                                       multiplier:1.0
                                                         constant:0.0]];
    
    [controlView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [containerView addSubview:controlView];
    [containerView addConstraints:constraints];
}

- (void)fitContainer:(UIView *)containerView {
    if ([[containerView subviews] count] > 0)
        [containerView addConstraint:[NSLayoutConstraint constraintWithItem:[[containerView subviews] lastObject]
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationLessThanOrEqual
                                                                     toItem:containerView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0]];
}

- (void)fitContentView {
    if (!self.contentView && !self.contentViewHeight)
        return;
    NSInteger maxY = 0;
    for (UIView* subview in self.contentView.subviews) {
        if (CGRectGetMaxY(subview.frame) > maxY) {
            maxY = CGRectGetMaxY(subview.frame);
        }
    }
    maxY += 16;
    self.contentViewHeight.constant = maxY;
}

- (void)fitContentViewToScreen {
    CGFloat navHeight = self.navigationController.navigationBarHidden ? 0 :
    self.navigationController.navigationBar.frame.size.height + 20;
    self.contentViewHeight.constant = [[UIScreen mainScreen] bounds].size.height - navHeight;
}

- (BOOL)startMediaBrowser:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[Helper localizedStringIfIsCode:@"_CANCEL"] style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])) {
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:[Helper localizedStringIfIsCode:@"_MEDIA_PICK_CAMERA"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self openMediaBrowser:UIImagePickerControllerSourceTypeCamera delegate:self];
        }];
        [alertController addAction:cameraAction];
    }
    
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:[Helper localizedStringIfIsCode:@"_MEDIA_PICK_GALLERY"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openMediaBrowser:UIImagePickerControllerSourceTypePhotoLibrary delegate:self];
    }];
    [alertController addAction:galleryAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    return  YES;
   }

- (BOOL)openMediaBrowser:(UIImagePickerControllerSourceType) sourceType delegate:(id <UIImagePickerControllerDelegate, UINavigationControllerDelegate>)delegate {
    if (delegate == nil) {
        return NO;
    }
    if (([UIImagePickerController isSourceTypeAvailable:sourceType] == NO)) {
        [self showAlert:@"Not supported"];
        return NO;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    
    // Displays saved pictures and movies, if both are available, from the
    // Camera Roll album.
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *)kUTTypeImage, nil];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    picker.allowsEditing = NO;
    picker.delegate = delegate;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]) {
            picker.cameraDevice =  UIImagePickerControllerCameraDeviceRear;
        } else {
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
    }
    
    [self presentViewController:picker animated:YES completion:nil];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (alertView.tag) {
        case 100:
            // logout
        {
            switch (buttonIndex) {
                case 1:
                {
                    [Helper clearAuthorized];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate setupNotAuthorizedNavigation];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        case 200:
            break;
            
        default:
            break;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CommonTextField class]]) {
        [(CommonTextField *)textField setFocus:YES];
        self.activeField = textField;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[CommonTextField class]]) {
        [(CommonTextField *)textField setFocus:NO];
    }
    self.activeField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isKindOfClass:[CommonTextField class]]) {
        CommonTextField *tf = (CommonTextField *)textField;
        NSString *result = [tf.text stringByReplacingCharactersInRange:range withString:string];
        if (tf.maximum > 0 && [result length] > tf.maximum) {
            [self showNotification:@"_STRING_LIMIT"];
            return NO;
        }
        [(CommonTextField *)textField onchange:result];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CommonTextView class]]) {
        [(CommonTextView *)textView setFocus:YES];
        self.activeField = textView;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isKindOfClass:[CommonTextView class]]) {
        [(CommonTextView *)textView setFocus:NO];
    }
    self.activeField = textView;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([textView isKindOfClass:[CommonTextView class]]) {
        CommonTextView *tv = (CommonTextView *)textView;
        NSString *result = [tv.text stringByReplacingCharactersInRange:range withString:text];
        if (tv.maximum > 0 && [result length] > tv.maximum) {
            [self showNotification:@"_STRING_LIMIT"];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView isKindOfClass:[CommonTextView class]])  {
        CommonTextView *tv = (CommonTextView *)textView;
        if (tv.placeholderLabel) {
            tv.placeholderLabel.hidden = [((CommonTextView *)textView).text length] > 0;
        }
        if (tv.maximum > 0 && [tv.text length] > tv.maximum) {
            [self showNotification:@"_STRING_LIMIT"];
            tv.text = [tv.text substringToIndex:tv.maximum];
        }
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source {
    
    MenuDialogViewController *menuViewController = (MenuDialogViewController *)presented;
    if (menuViewController) {
        menuViewController.presenting = YES;
        return menuViewController;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    MenuDialogViewController *menuViewController = (MenuDialogViewController *)dismissed;
    if (menuViewController) {
        menuViewController.presenting = NO;
        return menuViewController;
    }
    return nil;
}

- (void)setupAppearence {
    NSString *bgImageName;
    
    switch ([self appearenceStyle]) {
        case AppearenceStyleBLUE:
            bgImageName = @"dummy-blue.png";
            break;
            
        case AppearenceStyleDBLUE:
            bgImageName = @"dummy-dblue.png";
            break;
            
        case AppearenceStyleGREEN:
            bgImageName = @"dummy-green";
            break;
            
        case AppearenceStyleYELLOW:
            bgImageName = @"dummy-yellow";
            break;
            
        case AppearenceStylePURPLE:
            bgImageName = @"dummy-purple.png";
            break;
            
        case AppearenceStyleRED:
            bgImageName = @"dummy-red.png";
            break;
            
        case AppearenceStyleVIRID:
            bgImageName = @"dummy-blue.png";
            break;
            
        default:
            return;
    }

    UIColor *color = [self appearenceColor];
    self.navigationController.navigationBar.barTintColor = color;

    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    CGFloat red, green, blue;
    [color getRed:&red green:&green blue:&blue alpha:nil];
    statusBarView.backgroundColor = [UIColor colorWithRed:red * 0.8 green:green * 0.8 blue:blue * 0.8 alpha:1];
    [self.navigationController.view addSubview:statusBarView];
    
    MenuDialogViewController *menuDialogViewController = (MenuDialogViewController *)self.revealViewController.rearViewController;
    [menuDialogViewController setActiveMenuItem:[self activeMenuItem]];
}

@end
