//
//  UserFilterViewController.m
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "MDSwitch.h"
#import "UserFilterViewController.h"
#import "Constants.h"
#import "Helper.h"
#import "UIHelpers.h"
#import "UserFilter.h"

@interface UserFilterViewController ()

@end

@implementation UserFilterViewController {
    NSDictionary *sexOptions;
    NSDictionary *ageOptions;
    UIColor *switchOnLabelColor;
    UIColor *switchOffLabelColor;
    Location *selectedLocation;
    Location *selectedCountry;
    NSString *selectedSex;
    NSString *selectedAge;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Фильтр";
    
    ageOptions = @{ @"": @"любой",
                    @"18-25": @"18-25",
                    @"25-32": @"25-32",
                    @"32-39": @"32-39",
                    @"39-46": @"39-46",
                    @"46-53": @"46-53" };
    
    sexOptions = @{ @"": @"не важно",
                    @"1": @"мужской",
                    @"0": @"женский"};
    
    switchOffLabelColor = [UIColor colorWithRed:0.54 green:0.54 blue:0.54 alpha:1.0];
    switchOnLabelColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    
    [UIHelpers setShadow:self.filterContainer];
    
    [self.countryTextField setAppearenceColor:[self appearenceColor]];
    [self.cityTextField setAppearenceColor:[self appearenceColor]];
    [self.sexTextField setAppearenceColor:[self appearenceColor]];
    [self.ageTextField setAppearenceColor:[self appearenceColor]];
    
    [self.popularSwitch addTarget:self
                           action:@selector(updateState:)
                 forControlEvents:UIControlEventValueChanged];
    [self.isNewSwitch addTarget:self
                         action:@selector(updateState:)
               forControlEvents:UIControlEventValueChanged];
    [self.vipSwitch addTarget:self
                       action:@selector(updateState:)
             forControlEvents:UIControlEventValueChanged];
    [self.onlineSwitch addTarget:self
                          action:@selector(updateState:)
                forControlEvents:UIControlEventValueChanged];
    
    [self setFilterUI:self.filter];
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStyleVIRID;
}

- (NSInteger)activeMenuItem {
    return 6;
}

- (void)setFilterUI:(UserFilter *)filter {
    self.vipSwitch.on = filter.vip;
    self.onlineSwitch.on = filter.online;
    self.popularSwitch.on = filter.popular;
    self.isNewSwitch.on = filter.isnew;
    selectedSex = filter.sex;
    self.ageTextField.text = [ageOptions objectForKey:filter.age];
    selectedAge = filter.age;
    self.sexTextField.text = [sexOptions objectForKey:filter.sex];
    
    self.countryTextField.text = filter.countryName;
    [self.countryTextField triggerchange];
    selectedCountry = [[Location alloc] init];
    selectedCountry.id = filter.country;
    selectedCountry.name = filter.countryName;
    
    self.cityTextField.text = filter.cityName;
    [self.cityTextField triggerchange];
    selectedLocation = [[Location alloc] init];
    selectedLocation.id = filter.city;
    selectedLocation.name = filter.cityName;
}

- (void)updateState:(id)sender {
    MDSwitch *mdSwitch = (MDSwitch *)sender;
    UILabel *switchLabel;
    if (mdSwitch == self.popularSwitch) {
        switchLabel = self.popularLabel;
    }
    else if (mdSwitch == self.vipSwitch) {
        switchLabel = self.vipLabel;
    }
    if (mdSwitch == self.isNewSwitch) {
        switchLabel = self.isNewLabel;
    }
    if (mdSwitch == self.onlineSwitch) {
        switchLabel = self.onlineLabel;
    }
    if (switchLabel) {
        switchLabel.textColor = mdSwitch.on ? switchOnLabelColor : switchOffLabelColor;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.countryTextField == textField) {
        [self.view endEditing:YES];
        [self countryBeginSelect];
    }
    if (self.cityTextField == textField) {
        [self.view endEditing:YES];
        [self locationBeginSelect];
    }
    else if (self.sexTextField == textField) {
        [self.view endEditing:YES];
        [self setupDropdownActionSheet:sexOptions handler:^(NSString *value) {
            selectedSex = value;
            self.sexTextField.text = [sexOptions objectForKey:value];
        }];
    }
    else if (self.ageTextField == textField) {
        [self.view endEditing:YES];
        [self setupDropdownActionSheet:ageOptions handler:^(NSString *value) {
            selectedAge = value;
            self.ageTextField.text = [ageOptions objectForKey:value];
        }];
    }
    [super textFieldDidBeginEditing:textField];
}

- (void)setupDropdownActionSheet:(NSDictionary *)options handler:(void (^)(NSString *))handler {
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_CANCEL"] style:UIAlertActionStyleCancel handler:nil];
    [alertActions addObject:cancelAction];
    
    for (NSString *option in options) {
        NSString *optionName = [options objectForKey:option];
        UIAlertAction *action = [UIAlertAction actionWithTitle:optionName style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            handler(option);
        }];
        [alertActions addObject:action];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertController.popoverPresentationController.sourceView = self.view;
    
    for (id alertAction in alertActions) {
        [alertController addAction:alertAction];
    }
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)locationBeginSelect {
    LocationSelectViewController *locationController = [[LocationSelectViewController alloc] initWithNibName:@"LocationSelectViewController" bundle:nil];
    locationController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    locationController.modalPresentationStyle = UIModalPresentationCustom;
    locationController.selectedLocation = selectedLocation;
    locationController.country = selectedCountry.id;
    locationController.delegate = self;
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7)
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:locationController animated:YES completion:nil];
}

- (void)didLocationSelect:(Location *)location {
    selectedLocation = location;
    self.cityTextField.text = location.name;
    [self.cityTextField onchange:self.cityTextField.text];
    [self.cityTextField resignFirstResponder];
}

- (void)didLocationSelectCancel {
    [self.cityTextField resignFirstResponder];
}

- (void)countryBeginSelect {
    CountrySelectViewController *countryController = [[CountrySelectViewController alloc] initWithNibName:@"CountrySelectViewController" bundle:nil];
    countryController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    countryController.modalPresentationStyle = UIModalPresentationCustom;
    countryController.delegate = self;
    
    if ([UIDevice currentDevice].systemVersion.integerValue >= 7)
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    
    [self presentViewController:countryController animated:YES completion:nil];
}

- (void)didCountrySelect:(Location *)location {
    selectedCountry = location;
    self.countryTextField.text = location.name;
    [self.countryTextField onchange:self.countryTextField.text];
    [self.countryTextField resignFirstResponder];
}

- (void)didCountrySelectCancel {
    [self.countryTextField resignFirstResponder];
}

- (IBAction)applyTouch:(id)sender {
    if (!self.filter) {
        UserFilter *filter = [[UserFilter alloc] init];
        self.filter = filter;
    }
    self.filter.sex = selectedSex;
    self.filter.age = selectedAge;
    self.filter.country = selectedCountry.id;
    self.filter.countryName = selectedCountry.name;
    self.filter.city = selectedLocation.id;
    self.filter.cityName = selectedLocation.name;
    self.filter.isnew = self.isNewSwitch.on;
    self.filter.online = self.onlineSwitch.on;
    self.filter.vip = self.vipSwitch.on;
    self.filter.popular = self.popularSwitch.on;
    
    NSLog(@"filter: %@", self.filter);
    
    [self.filterDelegate filterApply:self.filter];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelTouch:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
