//
//  UserListViewController.m
//  MyDreams
//
//  Created by Игорь on 18.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UserListViewController.h"
#import "CommonListViewController.h"
#import "UserListCell.h"
#import "DreambookRootViewController.h"
#import "UserFilterViewController.h"

@interface UserListViewController ()

@end

@implementation UserListViewController {
    CommonListViewController *listViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommonListViewController *vc = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    listViewController = vc;
    
    self.title = @"Мечтатели";
    
    [self setupContextMenu];
    [self setup];
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStyleVIRID;
}

- (NSInteger)activeMenuItem {
    return 6;
}

-(BOOL)isSectionRoot {
    return YES;
}

- (void)setupContextMenu {
    UIImage *filterIcon = [UIImage imageNamed:@"menu-filter"];
    UIBarButtonItem *btnFilter = [[UIBarButtonItem alloc] initWithImage:filterIcon style:UIBarButtonItemStylePlain target:self action:@selector(goFilter)];
    self.navigationItem.rightBarButtonItems = @[btnFilter];
}

- (void)setup {
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager findusers:self.filter pager:pager success:^(NSInteger total, NSArray<BasicUser> *dreams) {
            callback(total, dreams);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:([UserListCell class]) andCellInitializer:^(UITableViewCell *cell, id listItem) {
        UserListCell *itemCell = (UserListCell *)cell;
        BasicUser *item = (BasicUser *)listItem;
        [itemCell initUIWith:item];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        BasicUser *item = (BasicUser *)listItem;
        [self goFlybook:item.id];
    }];
    [self present];
}

- (void)present {
    [self addChildViewController:listViewController];
    // хак: -8 - непонятный паддинг сверху(
    listViewController.view.frame = CGRectMake(0, -8.0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:listViewController.view];
    [listViewController didMoveToParentViewController:self];
}

- (void)goFlybook:(NSInteger)userId {
    DreambookRootViewController *dreambookViewController = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    dreambookViewController.userId = userId;
    [self.navigationController pushViewController:dreambookViewController animated:YES];
}

- (void)goFilter {
    UserFilterViewController *filterViewController = [[UserFilterViewController alloc] initWithNibName:@"UserFilterViewController" bundle:nil];
    filterViewController.filter = self.filter;
    filterViewController.filterDelegate = self;
    [self.navigationController pushViewController:filterViewController animated:YES];
}

- (void)filterApply:(UserFilter *)filter {
    self.filter = filter;
    [listViewController reload];
}

@end
