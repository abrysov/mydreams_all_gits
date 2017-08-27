//
//  CommonSearchViewController.h
//  MyDreams
//
//  Created by Игорь on 24.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonListViewController.h"
#import "CommonTextField.h"
#import "LocalizedButton.h"


@protocol CommonSearchViewControllerDelegate

- (void)didSearchSelect:(id)searchItem;
- (void)didSearchCancel;

@end


@interface CommonSearchViewController : BaseViewController

@property (weak, nonatomic) CommonListViewController *listViewController;
@property (weak, nonatomic) id<CommonSearchViewControllerDelegate> searchDelegate;

@property (weak, nonatomic) IBOutlet CommonTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchContainer;

- (IBAction)searchCancelTouch:(id)sender;

@end
