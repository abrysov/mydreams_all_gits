//
//  LoginViewController.h
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommonTextField.h"
#import "CommonLabel.h"
#import "BorderedButton.h"

@interface LoginViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet CommonTextField *loginTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *loginLabel;
@property (weak, nonatomic) IBOutlet CommonTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *passwordLabel;
@property (weak, nonatomic) IBOutlet UIButton *forgotButton;
@property (weak, nonatomic) IBOutlet BorderedButton *loginButton;

- (IBAction)loginTouch:(id)sender;
- (IBAction)forgotTouch:(id)sender;

@end
