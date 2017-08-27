//
//  LoginViewController.m
//  MyDreams
//
//  Created by Игорь on 26.08.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "LoginViewController.h"
#import "PostDreamViewController.h"
#import "Helper.h"
#import "ApiDataManager.h"
#import "AppDelegate.h"
#import "SignupViewController.h"
#import "Constants.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //спрятать нав-бар до fit'а
    self.navigationController.navigationBarHidden = YES;
    [self fitContentViewToScreen];
    
    [self.forgotButton setTitle:[[Helper localizedStringIfIsCode:self.forgotButton.titleLabel.text] uppercaseString] forState:UIControlStateNormal];
    
    [self.passwordTextField setLabel:self.passwordLabel];
    [self.loginTextField setLabel:self.loginLabel];
    
    [self.passwordTextField setAppearenceColor:[UIColor whiteColor]];
    self.passwordTextField.textColor = [UIColor whiteColor];
    [self.loginTextField setAppearenceColor:[UIColor whiteColor]];
    self.loginTextField.textColor = [UIColor whiteColor];
    
    self.logoImageView.image = [UIImage imageNamed:[Helper localizedString:@"_LOGO_IMAGE_OPAQ"]];
    self.view.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_PURPLE];
}

- (void)viewWillAppear:(BOOL)animated {
     self.navigationController.navigationBarHidden = YES;
    [super viewWillAppear:animated];
}

//- (void)viewDidAppear:(BOOL)animated {
////    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, 200, 0.0);
////    self.scrollView.contentInset = contentInsets;
////    self.scrollView.scrollIndicatorInsets = contentInsets;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (self.loginTextField == theTextField && [self validateLogin]) {
        [self.passwordTextField becomeFirstResponder];
    }
    else if (self.passwordTextField == theTextField && [self validatePassword]) {
        [self loginTouch:nil];
    }
    return [super textFieldShouldReturn:theTextField];
}

- (BOOL)validateLogin {
    if ([self.loginTextField.text length] == 0) {
        [self showNotification:@"_LOGIN_ENTER_LOGIN"];
        return NO;
    }
    return YES;
}

- (BOOL)validatePassword {
    if ([self.passwordTextField.text length] == 0) {
        [self showNotification:@"_LOGIN_ENTER_PASSWORD"];
        return NO;
    }
    return YES;
}

- (IBAction)loginTouch:(id)sender {
    if (![self validateLogin])
        return;
    if (![self validatePassword])
        return;
    if (!self.loginButton.enabled)
        return;
    
    self.loginButton.enabled = NO;
    
    [ApiDataManager login:self.loginTextField.text password:self.passwordTextField.text success:^(NSString *token) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setBool:YES forKey:@"authorized"];
        [defaults setObject:token forKey:@"token"];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate setupAuthorizedNavigation];
        
        self.loginButton.enabled = YES;
    } error:^(NSString *error) {
        [self showAlert:error];
        self.loginButton.enabled = YES;
    }];
}

- (IBAction)forgotTouch:(id)sender {
    SignupViewController *vc = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
