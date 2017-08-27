//
//  CommonSearchViewController.m
//  MyDreams
//
//  Created by Игорь on 24.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CommonSearchViewController.h"
#import "CommonListViewController.h"
#import "SimpleUserCell.h"
#import "Helper.h"

@interface CommonSearchViewController ()

@end

@implementation CommonSearchViewController {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommonListViewController *vc = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    self.listViewController = vc;
    
    [self setup];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //[self present];
}

- (void)setup {
    [self.listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager friends:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[SimpleUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        SimpleUserCell *itemCell = (SimpleUserCell *)cell;
        BasicUser *item = (BasicUser *)listItem;
        [itemCell initWithUser:item];
    } andSectionNameDelegate:^NSString *(id listItem) {
        BasicUser *item = (BasicUser *)listItem;
        NSString *itemName = [item.fullname stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return [[itemName substringToIndex:1] uppercaseString];
    } andSelectItem:^(id listItem) {
        [self.searchDelegate didSearchSelect:listItem];
    }];
    [self present];
}

- (void)present {
    //1. Add the detail controller as child of the container
    [self addChildViewController:self.listViewController];
    
    //2. Define the detail controller's view size
    self.listViewController.view.frame = CGRectMake(0, 0, self.searchContainer.frame.size.width, self.searchContainer.frame.size.height);
    
    //3. Add the Detail controller's view to the Container's detail view and save a reference to the detail View Controller
    [self.searchContainer addSubview:self.listViewController.view];
    //self.currentDetailViewController = detailVC;
    
    //4. Complete the add flow calling the function didMoveToParentViewController
    [self.listViewController didMoveToParentViewController:self];
}

- (IBAction)searchCancelTouch:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.searchDelegate didSearchCancel];
}

@end
