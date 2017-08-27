//
//  FriendsViewController.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "MDTabBarViewController.h"
#import "FriendsViewController.h"
#import "CommonListViewController.h"
#import "DreambookRootViewController.h"
#import "ApiDataManager.h"
#import "SimpleUserCell.h"
#import "ActionUserCell.h"
#import "TabsView.h"
#import "Helper.h"
#import "UIHelpers.h"


@interface FriendsViewController ()

@end


@implementation FriendsViewController {
    MDTabBarViewController *tabBarViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabs];
    
    self.title = [Helper localizedString:@"_MENU_FRIENDS"];
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStyleDBLUE;
}

- (NSInteger)activeMenuItem {
    return 3;
}

-(BOOL)isSectionRoot {
    return YES;
}

- (void)setupTabs {
    tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self];
    [UIHelpers setTabBarAppearence:tabBarViewController.tabBar];
    
    [tabBarViewController setItems:@[@"Друзья", @"Заявки", @"Подписчики", @"Я подписан"]];
    [self addChildViewController:tabBarViewController];
    [self.view addSubview:tabBarViewController.view];
    [tabBarViewController didMoveToParentViewController:self];
    
    UIView *controllerView = tabBarViewController.view;
    id<UILayoutSupport> rootTopLayoutGuide = self.topLayoutGuide;
    id<UILayoutSupport> rootBottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(rootTopLayoutGuide, rootBottomLayoutGuide, controllerView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rootTopLayoutGuide]["@"controllerView][" @"rootBottomLayoutGuide]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controllerView]|" options:0 metrics:nil views:viewsDictionary]];
}

- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [self setupFriendsTabContent];
            
        case 1:
            return [self setupRequestsTabContent];
            
        case 2:
            return [self setupSubscribersTabContent];
            
        case 3:
            return [self setupSubscribedTabContent];
            
        default:
            return [self setupFriendsTabContent];
    }
}

- (void)needUpdateTabs:(UIViewController *)sender {
    
    NSMutableDictionary *viewControllers = [tabBarViewController valueForKey:@"viewControllers"];
    for (NSNumber *i in viewControllers) {
        CommonListViewController *vc = [viewControllers objectForKey:i];
        [vc reload];
    }
    
//    [ApiDataManager dream:self.dreamId success:^(Dream *dream_) {
//        dream = dream_;
//        NSString *currentTabName = [tabIndexes objectForKey:[NSNumber numberWithUnsignedLong:tabBarViewController.tabBar.selectedIndex]];
//        [tabBarViewController setItems:[self setupTabsItems]];
//        // удалить, тк кешируются
//        NSMutableDictionary *viewControllers = [tabBarViewController valueForKey:@"viewControllers"];
//        [viewControllers removeAllObjects];
//        NSInteger i = [self indexOfTabBy:currentTabName inDict:tabIndexes];
//        tabBarViewController.tabBar.selectedIndex = i != -1 ? i : 0;
//        
//    } error:^(NSString *error) {
//        [self showAlert:error];
//    }];
    
}

- (UIViewController *)setupFriendsTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
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
        BasicUser *item = (BasicUser *)listItem;
        [self goFlybook:item.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupRequestsTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager requests:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[ActionUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        ActionUserCell *itemCell = (ActionUserCell *)cell;
        BasicUser *item = (BasicUser *)listItem;
        [itemCell initWithUser:item andMode:@"requests"];
        itemCell.delegate = self;
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        BasicUser *item = (BasicUser *)listItem;
        [self goFlybook:item.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupSubscribersTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager subscribers:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[ActionUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        ActionUserCell *itemCell = (ActionUserCell *)cell;
        BasicUser *item = (BasicUser *)listItem;
        [itemCell initWithUser:item andMode:@"subscribers"];
        itemCell.delegate = self;
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        BasicUser *item = (BasicUser *)listItem;
        [self goFlybook:item.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupSubscribedTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager subscribed:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[ActionUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        ActionUserCell *itemCell = (ActionUserCell *)cell;
        BasicUser *item = (BasicUser *)listItem;
        [itemCell initWithUser:item andMode:@"subscribed"];
        itemCell.delegate = self;
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        BasicUser *item = (BasicUser *)listItem;
        [self goFlybook:item.id];
    }];
    
    return listViewController;
}

- (void)goFlybook:(NSInteger)userId {
    DreambookRootViewController *vc = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    vc.userId = userId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
