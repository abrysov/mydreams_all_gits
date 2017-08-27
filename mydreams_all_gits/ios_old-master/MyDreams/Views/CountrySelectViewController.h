//
//  CountrySelectViewController.h
//  MyDreams
//
//  Created by Игорь on 26.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Location.h"

@protocol CountrySelectViewControllerDelegate <NSObject>
- (void)didCountrySelect:(Location *)location;
- (void)didCountrySelectCancel;
@end

@interface CountrySelectViewController : BaseViewController
@property (weak, nonatomic) id<CountrySelectViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *countryTable;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
- (IBAction)cancelTouch:(id)sender;
@end
