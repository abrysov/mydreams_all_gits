//
//  SignupViewController.m
//  MyDreams
//
//  Created by Игорь on 06.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import <RMDateSelectionViewController/RMDateSelectionViewController.h>
#import "SignupViewController.h"
#import "BorderedButton.h"
#import "LocationSelectViewController.h"
#import "Helper.h"
#import "Constants.h"
#import "ApiDataManager.h"
#import "AppDelegate.h"

@interface SignupViewController ()<UIPopoverPresentationControllerDelegate>

@end

@implementation SignupViewController {
    NSInteger selectedSex;
    BOOL agreed;
    CLLocationManager *locationManager;
    NSDate *selectedBirthDate;
    Location *selectedLocation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.topItem.title = @"Регистрация";
    
    [self setupControls];
    [self setupValidation];
    
    [self sexTouch:self.femaleSexBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupLocationManager];
}

- (void)setupControls {
    [BorderedButton localize:self.maleSexLabelBtn];
    [BorderedButton localize:self.femaleSexLabelBtn];
    [BorderedButton localize:self.agreeLabelBtn];
    
    [self.nameTextField setLabel:self.nameLabel];
    [self.surnameTextField setLabel:self.surnameLabel];
    [self.emailTextField setLabel:self.emailLabel];
    [self.phoneTextField setLabel:self.phoneLabel];
    [self.passwordTextField setLabel:self.passwordLabel];
    [self.repeatTextField setLabel:self.repeatLabel];
    [self.locationTextField setLabel:self.locationLabel];
    [self.birthTextField setLabel:self.birthLabel];
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
    
    self.phoneTextField.minimum = 0;//9;
    self.phoneTextField.maximum = 0;//14;
    self.phoneTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_PHONE_MATCH"];
    self.phoneTextField.pattern = PHONE_REGEX_PATTERN;
    self.phoneTextField.patternMsg = [Helper localizedString:@"_SIGNUP_PHONE_MATCH"];
    
    self.passwordTextField.required = YES;
    self.passwordTextField.requiredMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_NO"];
    self.passwordTextField.pattern = PASSWORD_REGEX_PATTERN;
    self.passwordTextField.patternMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_MATCH"];
    self.passwordTextField.minimum = 6;
    self.passwordTextField.maximum = 20;
    self.passwordTextField.limitsMsg = [Helper localizedString:@"_SIGNUP_PASSWORD_LIMITS"];
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
    if ([self.passwordTextField.text isEqualToString:self.repeatTextField.text]) {
        return YES;
    }
    else {
        [self showNotification:@"_SIGNUP_REPEAT_MATCH"];
        return NO;
    }
}

- (BOOL)validateSex {
    return YES;
}

- (BOOL)validateBirthdate {
    return YES;
}

- (BOOL)validateLocation {
    return YES;
}

- (BOOL)validateAgreement {
    if (!agreed) {
        [self showNotification:@"_SIGNUP_AGREE_NO"];
        return NO;
    }
    return YES;
}

- (BOOL)validate {
    return [self validateName]
        && [self validateSurname]
        && [self validateEmail]
        && [self validatePhone]
        && [self validatePassword]
        && [self validateRepeat]
        && [self validateSex]
        && [self validateBirthdate]
        && [self validateLocation]
        && [self validateAgreement];
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
        [self.passwordTextField becomeFirstResponder];
    }
    else if (self.passwordTextField == textField && [self validatePassword]) {
        [self.repeatTextField becomeFirstResponder];
    }
    else if (self.repeatTextField == textField && [self validateRepeat]) {
        [self.birthTextField becomeFirstResponder];
    }
    return [super textFieldShouldReturn:textField];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.birthTextField == textField) {
        [self.view endEditing:YES];
        [self datepickerBeginSelect];
        return NO;
    }
    else if (self.locationTextField == textField) {
        [self.view endEditing:YES];
        [self locationBeginSelect];
        return NO;
    }
    return YES;
}

- (void)setupLocationManager {
    if (locationManager) {
        
    }
    else if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        dispatch_async(dispatch_get_main_queue(),^ {
            if (placemarks.count == 1) {
                CLPlacemark *place = [placemarks objectAtIndex:0];
                [self performSelectorInBackground:@selector(locationFound:) withObject:place];
            }
        });
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"locationManager:%@ didFailWithError:%@", manager, error);
}

- (void)locationFound:(CLPlacemark *)place {
    NSString *city = [place.addressDictionary objectForKey:(NSString *)kABPersonAddressCityKey];
    double lat = place.location.coordinate.latitude;
    double lng = place.location.coordinate.longitude;
    NSLog(@"%@", city);
    [ApiDataManager findlocations:city country:0 lat:lat lng:lng success:^(NSArray<Location> *locations) {
        if ([locations count] == 1) {
            Location *location = [locations objectAtIndex:0];
            [self updateLocation:location];
            NSLog(@"Found location:id %ld, %@", (long)selectedLocation.id, selectedLocation.name);
        }
        else {
            NSLog(@"Locations found: %ld", (long)[locations count]);
        }
    } error:^(NSString *error) {
        selectedLocation = nil;
    }];
    
    [locationManager stopUpdatingLocation];
}

- (void)updateLocation:(Location *)location {
    selectedLocation = location;
    self.locationTextField.text = location.name;
    [self.locationTextField onchange:self.locationTextField.text];
}

- (IBAction)sexTouch:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    if (tag == 1) {
        selectedSex = 1;
        [self.maleSexBtn setBackgroundImage:[UIImage imageNamed:@"Checked Radiobutton.png"] forState:UIControlStateNormal];
        [self.femaleSexBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Radiobutton.png"] forState:UIControlStateNormal];
    }
    else if (tag == 2) {
        selectedSex = 2;
        [self.maleSexBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Radiobutton.png"] forState:UIControlStateNormal];
        [self.femaleSexBtn setBackgroundImage:[UIImage imageNamed:@"Checked Radiobutton.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)agreeTouch:(id)sender {
    if (agreed) {
        agreed = NO;
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"Unchecked Checkbox-48.png"] forState:UIControlStateNormal];
    }
    else {
        agreed = YES;
        [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"Checked Checkbox-48.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)registerTouch:(id)sender {
    if (![self validate]) {
        return;
    }
    
    self.signupBtn.enabled = NO;
    
    [ApiDataManager signup:self.emailTextField.text
                  password:self.passwordTextField.text
                      name:self.nameTextField.text
                   surname:self.surnameTextField.text
                     phone:self.phoneTextField.text
                       sex:selectedSex
                  birthday:selectedBirthDate
                  location:selectedLocation.id
                   success:^(NSString *empty) {
                       //[self.navigationController popViewControllerAnimated:YES];
                       
                       [self showAlert:@"_SIGNUP_SUCCESS"];
                       
                       // логин сразу после регистрации
                       [ApiDataManager login:self.emailTextField.text password:self.passwordTextField.text success:^(NSString *token) {
                           NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                           [defaults setBool:YES forKey:@"authorized"];
                           [defaults setObject:token forKey:@"token"];
                           
                           // еще один запрос - профиль - нужен наш id
                           [ApiDataManager flybook:0 success:^(Flybook *profile) {
                               [Helper updateProfile:profile];
                               [(AppDelegate *)[UIApplication sharedApplication].delegate setupAuthorizedNavigation];
                           } error:^(NSString *err) {
                               [self showAlert:err];
                           }];
                           
                       } error:^(NSString *error) {
                           [self showAlert:error];
                       }];
                       
                    } error:^(NSString *err) {
                       [self showAlert:err];
                       self.signupBtn.enabled = YES;
                   }];
}

- (void)datepickerBeginSelect {
    RMAction *selectAction = [RMAction actionWithTitle:[Helper localizedString:@"_SELECT"] style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
        NSDate *date = ((UIDatePicker *)controller.contentView).date;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MMMM yyyy"];
        
        selectedBirthDate = date;
        self.birthTextField.text = [dateFormat stringFromDate:date];
        [self.birthTextField onchange:self.birthTextField.text];
        [self.birthTextField resignFirstResponder];
    }];
    
    RMAction *cancelAction = [RMAction actionWithTitle:[Helper localizedString:@"_CANCEL"] style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        [self.birthTextField resignFirstResponder];
    }];
    
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite selectAction:selectAction andCancelAction:cancelAction];
    dateSelectionController.disableBlurEffects = YES;
    dateSelectionController.title = [Helper localizedString:@"_SELECT_DATE"];
    
    if (selectedBirthDate) {
        dateSelectionController.datePicker.date = selectedBirthDate;
    }
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDate;
    dateSelectionController.datePicker.minimumDate = [Helper getDate:1900 month:01 day:01];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:unitFlags fromDate:now];
    [components setYear:[components year] - 18];
    NSDate *maximumDate = [calendar dateFromComponents:components];

    dateSelectionController.datePicker.maximumDate = maximumDate;
   
    [self presentViewController:dateSelectionController animated:YES completion:nil];
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

@end
