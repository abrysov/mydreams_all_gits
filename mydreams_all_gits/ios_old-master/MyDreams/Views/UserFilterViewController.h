//
//  UserFilterViewController.h
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "MDSwitch.h"
#import "BaseViewController.h"
#import "CommonLabel.h"
#import "DOPDropDownMenu.h"
#import "LocationSelectViewController.h"
#import "CountrySelectViewController.h"
#import "UserFilter.h"

@protocol UserFilterApplyDelegate <NSObject>
- (void)filterApply:(UserFilter *)filter;
@end

@interface UserFilterViewController : BaseViewController<LocationSelectViewControllerDelegate, CountrySelectViewControllerDelegate>

@property (strong, nonatomic) UserFilter *filter;
@property (weak, nonatomic) id<UserFilterApplyDelegate> filterDelegate;

@property (weak, nonatomic) IBOutlet UIView *filterContainer;
@property (weak, nonatomic) IBOutlet CommonTextField *countryTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *cityTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *sexTextField;
@property (weak, nonatomic) IBOutlet CommonTextField *ageTextField;

@property (weak, nonatomic) IBOutlet CommonLabel *popularLabel;
@property (weak, nonatomic) IBOutlet MDSwitch *popularSwitch;
@property (strong, nonatomic) IBOutlet CommonLabel *isNewLabel;
@property (weak, nonatomic) IBOutlet MDSwitch *isNewSwitch;
@property (weak, nonatomic) IBOutlet CommonLabel *vipLabel;
@property (weak, nonatomic) IBOutlet MDSwitch *vipSwitch;
@property (weak, nonatomic) IBOutlet CommonLabel *onlineLabel;
@property (weak, nonatomic) IBOutlet MDSwitch *onlineSwitch;
- (IBAction)applyTouch:(id)sender;
- (IBAction)cancelTouch:(id)sender;

@end
