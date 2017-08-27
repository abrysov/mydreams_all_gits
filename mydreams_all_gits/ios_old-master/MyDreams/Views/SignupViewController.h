//
//  SignupViewController.h
//  MyDreams
//
//  Created by Игорь on 06.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "BaseViewController.h"
#import "CommonLabel.h"
#import "BorderedButton.h"
#import "CommonTextField.h"
#import "LocationSelectViewController.h"

@interface SignupViewController : BaseViewController<CLLocationManagerDelegate, LocationSelectViewControllerDelegate>

@property (nonatomic, retain) UIPopoverController *datepickerController;
@property (nonatomic, retain) UIPopoverPresentationController *popoverPresentationController;

//@property (nonatomic,retain) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet CommonTextField *nameTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *surnameTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *emailTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *phoneTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *repeatTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *nameLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *surnameLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *emailLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *phoneLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *passwordLabel;
@property (weak, nonatomic) IBOutlet CommonLabel *repeatLabel;
@property (weak, nonatomic) IBOutlet CommonTextField *birthTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *birthLabel;
@property (weak, nonatomic) IBOutlet CommonTextField *locationTextField;
@property (weak, nonatomic) IBOutlet CommonLabel *locationLabel;
@property (weak, nonatomic) IBOutlet UIButton *maleSexBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleSexBtn;
@property (weak, nonatomic) IBOutlet UIButton *maleSexLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleSexLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeLabelBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

- (IBAction)sexTouch:(id)sender;
- (IBAction)agreeTouch:(id)sender;
@property (weak, nonatomic) IBOutlet CommonTextField *locationTouch;

@property (weak, nonatomic) IBOutlet BorderedButton *signupBtn;

- (IBAction)registerTouch:(id)sender;
@end
