//
//  DreamMainViewController.m
//  MyDreams
//
//  Created by Игорь on 20.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "MDTabBarViewController.h"
#import "DreamRootViewController.h"
#import "CommonListViewController.h"
#import "DreamMainViewController.h"
#import "DreamCommentsViewController.h"
#import "TabsView.h"
#import "CommentUserCell.h"
#import "ApiDataManager.h"
#import "SegmentedTabsView.h"
#import "Helper.h"
#import "DreamStamp.h"
#import "DreamLike.h"
#import "DreamComment.h"
#import "LikeUserCell.h"
#import "DreambookRootViewController.h"
#import "PostDreamViewController.h"
#import "Constants.h"
#import "UIHelpers.h"

@interface DreamRootViewController ()

@end

@implementation DreamRootViewController {
    Dream *dream;
    NSDictionary *tabIndexes;
    MDTabBarViewController *tabBarViewController;
    CommonSearchViewController *searchViewController;
    NSInteger selectedProposeUserId;
    BOOL isSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self performLoading];
}

- (AppearenceStyle)appearenceStyle {
    BOOL isVip = isSelf ? [Helper profileIsVip] : (dream.owner ? dream.owner.isVip : NO);
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return 2;
}

- (NSArray *)setupAlertActions {
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *proposeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_DREAM_PROPOSE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self presentSearchFriendsViewController];
    }];
    [alertActions addObject:proposeAction];
    
    if (!isSelf) {
        UIAlertAction *takeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_DREAM_TAKE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dreamTakeConfirm];
        }];
        [alertActions addObject:takeAction];
    }
    else {
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_DREAM_EDIT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self goEdit];
        }];
        [alertActions addObject:editAction];
        
        if (!dream.isdone) {
            UIAlertAction *doneAction = [UIAlertAction actionWithTitle:[Helper localizedString:dream.isdone ? @"_DREAM_MARK_NOTDONE" : @"_DREAM_MARK_DONE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self toggleIsDone];
            }];
            [alertActions addObject:doneAction];
        }
    }
    
    return alertActions;
}

- (void)performLoading {
    [ApiDataManager dream:self.dreamId success:^(Dream *dream_) {
        dream = dream_;
        isSelf = dream.owner.id == [Helper profileUserId];
        self.title = dream_.name;
        [self setupTabs];
        [self setupContextMenu];
        [self setupAppearence];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)needUpdateTabs:(UIViewController *)sender {
    [ApiDataManager dream:self.dreamId success:^(Dream *dream_) {
        dream = dream_;
        
        // сохраняем текущий таб
        NSString *currentTabName = [tabIndexes objectForKey:[NSNumber numberWithUnsignedLong:tabBarViewController.tabBar.selectedIndex]];
        
        // сохраняем старые табы
        NSDictionary *oldTabIndexes = [[NSDictionary alloc] initWithDictionary:tabIndexes];
        
        // генерируем новые табы и индексы
        [tabBarViewController setItems:[self setupTabsItems]];
        
        // здесь хак - свойство не выставлено наружу, надо пересчитать индексы в словаре
        NSMutableDictionary *viewControllers = [tabBarViewController valueForKey:@"viewControllers"];
        
        // формируем новый словарь табов
        NSMutableDictionary *newViewControllers = [[NSMutableDictionary alloc] init];
        for (NSNumber *key in oldTabIndexes) {
            NSString *tabCode = [oldTabIndexes objectForKey:key];
            NSInteger newIndexOfTab = [self indexOfTabBy:tabCode inDict:tabIndexes];
            if (newIndexOfTab != -1) {
                UIViewController *vc = [viewControllers objectForKey:key];
                if (vc != nil) {
                    [newViewControllers setObject:vc forKey:[NSNumber numberWithInteger:newIndexOfTab]];
                    if (vc && [vc isKindOfClass:[CommonListViewController class]]) {
                        [((CommonListViewController *)vc) reload];
                    }
                }
            }
        }
        
        // заменяем значения
        [viewControllers removeAllObjects];
        [viewControllers addEntriesFromDictionary:newViewControllers];
        
        NSInteger i = [self indexOfTabBy:currentTabName inDict:tabIndexes];
        tabBarViewController.tabBar.selectedIndex = i != -1 ? i : 0;
        
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (NSInteger)indexOfTabBy:(NSString *)name inDict:(NSDictionary *)tabIndexes_ {
    for (NSNumber *key in tabIndexes_) {
        NSString *value = [tabIndexes_ objectForKey:key];
        if ([value isEqualToString:name]) {
            return [key integerValue];
        }
    }
    return -1;
}

- (void)setupTabs {
    tabBarViewController = [[MDTabBarViewController alloc] initWithDelegate:self];
    tabBarViewController.tabBar.backgroundColor = [self appearenceColor];
    [UIHelpers setTabBarAppearence:tabBarViewController.tabBar];
    
    [tabBarViewController setItems:[self setupTabsItems]];
    [self addChildViewController:tabBarViewController];
    [self.view addSubview:tabBarViewController.view];
    [tabBarViewController didMoveToParentViewController:self];
    
    UIView *controllerView = tabBarViewController.view;
    id<UILayoutSupport> rootTopLayoutGuide = self.topLayoutGuide;
    id<UILayoutSupport> rootBottomLayoutGuide = self.bottomLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(rootTopLayoutGuide, rootBottomLayoutGuide, controllerView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rootTopLayoutGuide]["@"controllerView]["@"rootBottomLayoutGuide]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controllerView]|" options:0 metrics:nil views:viewsDictionary]];
}

- (NSArray *)setupTabsItems {
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[@"Описание"]];
    NSMutableDictionary *tabIndexes_ = [[NSMutableDictionary alloc] initWithObjects:@[@"main"] forKeys:@[[NSNumber numberWithUnsignedLong:0]]];
    
    if ([dream.likes longValue] > 0) {
        [items addObject:[Helper localizedStringWithDeclension:@"_LIKES_DECLENSION"
                                                        number:[dream.likes longValue]]];
        [tabIndexes_ setObject:@"likes" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    }
    if ([dream.stamps longValue] > 0) {
        [items addObject:[Helper localizedStringWithDeclension:@"_STAMPS_DECLENSION"
                                                        number:[dream.stamps longValue]]];
        [tabIndexes_ setObject:@"stamps" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    }
    [items addObject:[Helper localizedStringWithDeclension:@"_COMMENTS_DECLENSION"
                                                    number:[dream.comments longValue]]];
    [tabIndexes_ setObject:@"comments" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    tabIndexes = [[NSDictionary alloc] initWithDictionary:tabIndexes_];
    return items;
}

- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index {
    NSString *tabName = [tabIndexes objectForKey:[NSNumber numberWithUnsignedLong:index]];
    
    if ([tabName isEqualToString:@"main"]) {
        return [self setupMainTabContent];
    }
    else if ([tabName isEqualToString:@"likes"]) {
        return [self setupLikesTabContent];
    }
    else if ([tabName isEqualToString:@"stamps"]) {
        return [self setupStampsTabContent];
    }
    else if ([tabName isEqualToString:@"comments"]) {
        return [self setupCommentsTabContent];
    }
    
    return [self setupMainTabContent];
}

- (UIViewController *)setupMainTabContent {
    DreamMainViewController *dreamMainViewController = [[DreamMainViewController alloc] initWithNibName:@"DreamMainViewController" bundle:nil];
    dreamMainViewController.dream = dream;
    dreamMainViewController.delegate = self;
    return dreamMainViewController;
}

- (UIViewController *)setupLikesTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager dreamlikes:dream.id pager:pager success:^(NSInteger total, NSArray<DreamLike> *items) {
            callback(total, items);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[LikeUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        LikeUserCell *itemCell = (LikeUserCell *)cell;
        DreamLike *item = (DreamLike *)listItem;
        [itemCell initWithLike:item];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        DreamLike *item = (DreamLike *)listItem;
        [self navigateFlybook:item.user.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupStampsTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager dreamstamps:dream.id pager:pager success:^(NSInteger total, NSArray<DreamStamp> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[LikeUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        LikeUserCell *itemCell = (LikeUserCell *)cell;
        DreamStamp *item = (DreamStamp *)listItem;
        [itemCell initWithStamp:item];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        DreamStamp *item = (DreamStamp *)listItem;
        [self navigateFlybook:item.user.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupCommentsTabContent {
    DreamCommentsViewController *commentsViewController = [[DreamCommentsViewController alloc] initWithNibName:@"DreamCommentsViewController" bundle:nil];
    commentsViewController.dreamId = dream.id;
    commentsViewController.delegate = self;
    return commentsViewController;
}

- (void)navigateFlybook:(NSInteger)userId {
    DreambookRootViewController *dreambookViewController = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    dreambookViewController.userId = userId;
    [self.navigationController pushViewController:dreambookViewController animated:YES];
}

- (void)presentSearchFriendsViewController {
    searchViewController = [[CommonSearchViewController alloc] initWithNibName:@"CommonSearchViewController" bundle:nil];
    searchViewController.searchDelegate = self;
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:searchViewController animated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 9999) {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
        return;
    }
    switch (buttonIndex) {
        case 1:
            [self dreamPropose:selectedProposeUserId];
            break;
            
        default:
            break;
    }
}

- (void)didSearchSelect:(id)searchItem {
    BasicUser *user = (BasicUser *)searchItem;
    selectedProposeUserId = user.id;
    NSString *message = [NSString stringWithFormat:[Helper localizedString:@"_DREAM_PROPOSE_CONFIRM"], dream.name, user.fullname];
    UIAlertView *alert = [self showConfirmationDialog:@"Предложить мечту" message:message delegate:self];
    alert.tag = 9999;
}

- (void)didSearchCancel {
    //
}

- (void)dreamPropose:(NSInteger)userId {
    [ApiDataManager dreampropose:self.dreamId toUser:userId success:^{
        [self showAlert:@"_DREAM_PROPOSE_SUCCESS"];
        [searchViewController dismissViewControllerAnimated:YES completion:nil];
    } error:^(NSString *message) {
        [self showAlert:message];
    }];
}

- (void)dreamTake {
    [ApiDataManager dreamtake:dream.id success:^{
        [self showAlert:@"_DREAM_TAKE_SUCCESS"];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)dreamTakeConfirm {
    // todo alert
    [self dreamTake];
}

- (void)goEdit {
    PostDreamViewController *postViewController = [[PostDreamViewController alloc] initWithNibName:@"PostDreamViewController" bundle:nil];
    postViewController.editedDreamId = self.dreamId;
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)toggleIsDone {
    [ApiDataManager dreammarkdone:dream.id isdone:!dream.isdone success:^{
        dream.isdone = !dream.isdone;
        [self showAlert:dream.isdone ? @"_DREAM_DONE_SUCCESS" : @"_DREAM_NOTDONE_SUCCESS"];
        [Helper setNeedsUpdate:YES];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

@end
