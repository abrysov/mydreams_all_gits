//
//  LocationSelectViewController.h
//  MyDreams
//
//  Created by Игорь on 12.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTextField.h"
#import "CommonLabel.h"
#import "BaseViewController.h"
#import "Location.h"

@protocol LocationSelectViewControllerDelegate <NSObject>
- (void)didLocationSelect:(Location *)location;
- (void)didLocationSelectCancel;
@end

@interface LocationSelectViewController : BaseViewController

@property (assign, nonatomic) NSInteger country;
@property (retain, nonatomic) Location *selectedLocation;
@property (weak, nonatomic) id<LocationSelectViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet CommonTextField *locationTextField;
@property (weak, nonatomic) IBOutlet UILabel *nothingLabel;
@property (weak, nonatomic) IBOutlet UITableView *locationsTable;
- (IBAction)cancelTouch:(id)sender;
@end
