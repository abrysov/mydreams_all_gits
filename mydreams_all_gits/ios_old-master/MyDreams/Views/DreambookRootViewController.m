//
//  DreambookRootViewController.m
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "DreambookRootViewController.h"
#import "MDTabBarViewController.h"
#import "CommonListViewController.h"
#import "DreambookProfileViewController.h"
#import "EditProfileViewController.h"
#import "ProfilePhotosViewController.h"
#import "DreamRootViewController.h"
#import "ProposedDreamsViewController.h"
#import "PostRootViewController.h"
#import "PostPostViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"
#import "DreamCell.h"
#import "Dream.h"
#import "Post.h"
#import "PostCell.h"
#import "UIHelpers.h"

@interface DreambookRootViewController ()

@end

@implementation DreambookRootViewController {
    BOOL isSelf;
    BOOL isVip;
    Flybook *flybook;
    MDTabBarViewController *tabBarViewController;
    NSDictionary *tabIndexes;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelf = self.userId == 0 || self.userId == [Helper profileUserId];
    
    self.title = [Helper localizedString:@"_FLYBOOK_TITLE"];
    
    [self performLoading];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([Helper needsUpdate]) {
        [self needUpdateTabs:nil];
        [Helper setNeedsUpdate:NO];
    }
}

- (AppearenceStyle)appearenceStyle {
    isVip = isSelf ? [Helper profileIsVip] : (flybook ? [flybook isVip] : false);
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return isSelf ? 2 : -1;
}

-(BOOL)isSectionRoot {
    return YES;
}

- (void)performLoading {
    [ApiDataManager flybook:self.userId success:^(Flybook *flybook_) {
        flybook = flybook_;
        isVip = flybook_.isVip;
        
        if (isSelf) {
            [Helper updateProfile:flybook_];
        }
        
        [self setupTabs];
        [self setupContextMenu];
        [self setupAppearence];
        [Helper setNeedsUpdate:NO];
        
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (NSArray *)setupAlertActions {
    if (isSelf) {
        return [self setupSelfAlertActions];
    }
    else {
        return [self setupUserAlertActions];
    }
}

- (NSArray *)setupSelfAlertActions {
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *proposeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_PROFILE_EDIT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goEdit];
    }];
    [alertActions addObject:proposeAction];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_PROFILE_PHOTOS"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goPhotos];
    }];
    [alertActions addObject:photosAction];
    
    UIAlertAction *addPostAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_ADDPOST"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goAddPost];
    }];
    [alertActions addObject:addPostAction];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_LOGOUT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self logout];
    }];
    [alertActions addObject:logoutAction];
    
    return alertActions;
}

- (NSArray *)setupUserAlertActions {
    if (flybook == nil) {
        return nil;
    }
    
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_ALBUM"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goPhotos];
    }];
    [alertActions addObject:photosAction];
    
    if (flybook.friend) {
        UIAlertAction *unfriendAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_DELETE_FRIEND"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self unfriend:flybook.id];
        }];
        [alertActions addObject:unfriendAction];
    }
    else if (!flybook.friendshipRequestSended) {
        UIAlertAction *requestAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_ADD_FRIEND"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self requestFriendship:flybook.id];
        }];
        [alertActions addObject:requestAction];
    }
    else {
        UIAlertAction *denyAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_DENY_FRIENDREQUEST"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self denyrequest:flybook.id];
        }];
        [alertActions addObject:denyAction];
    }
    
    if (flybook.subscribed) {
        UIAlertAction *unsubscribeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_UNSUBSCRIBE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self unsubscribe:flybook.id];
        }];
        [alertActions addObject:unsubscribeAction];
    }
    else {
        UIAlertAction *subscribeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_FLYBOOK_SUBSCRIBE"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self subscribe:flybook.id];
        }];
        [alertActions addObject:subscribeAction];
    }
    
    return alertActions;
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
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[rootTopLayoutGuide]["@"controllerView][" @"rootBottomLayoutGuide]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controllerView]|" options:0 metrics:nil views:viewsDictionary]];
}

- (NSArray *)setupTabsItems {
    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[[Helper localizedString:@"_FLYBOOK_PROFILE"]]];
    NSMutableDictionary *tabIndexes_ = [[NSMutableDictionary alloc] initWithObjects:@[@"main"] forKeys:@[[NSNumber numberWithUnsignedLong:0]]];
    
    [items addObject:[Helper localizedStringWithDeclension:@"_DREAMS_DECLENSION"
                                                    number:[flybook.dreams longValue]]];
    [tabIndexes_ setObject:@"dreams" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    
    long dreamsDone = [flybook.dreamsComplete longValue];
    if (dreamsDone > 0) {
        [items addObject:[Helper localizedStringWithDeclension:@"_DREAMSDONE_DECLENSION"
                                                        number:dreamsDone]];
        [tabIndexes_ setObject:@"dreamsdone" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    }
    
    [items addObject:[Helper localizedStringWithDeclension:@"_POSTS_DECLENSION"
                                                    number:[flybook.posts longValue]]];
    [tabIndexes_ setObject:@"posts" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    
    tabIndexes = tabIndexes_;
    return items;
}

- (UIViewController *)tabBarViewController:(MDTabBarViewController *)viewController viewControllerAtIndex:(NSUInteger)index {
    NSString *tabName = [tabIndexes objectForKey:[NSNumber numberWithUnsignedLong:index]];
    
    if ([tabName isEqualToString:@"main"]) {
        return [self setupProfileViewController];
    }
    else if ([tabName isEqualToString:@"dreams"]) {
        return [self setupDreamsViewController];
    }
    else if ([tabName isEqualToString:@"dreamsdone"]) {
        return [self setupDreamsDoneViewController];
    }
    else if ([tabName isEqualToString:@"posts"]) {
        return [self setupPostsViewController];
    }
    return nil;
}

- (UIViewController*)setupProfileViewController {
    DreambookProfileViewController *vc = [[DreambookProfileViewController alloc] initWithNibName:@"DreambookProfileViewController" bundle:nil];
    vc.profile = flybook;
    vc.tabsDelegate = self;
    return vc;
}

- (UIViewController*)setupDreamsViewController {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager flybooklist:self.userId isdone:0 pager:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[DreamCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        DreamCell *itemCell = (DreamCell *)cell;
        Dream *item = (Dream *)listItem;
        [itemCell initUIWith:item andAppearence:isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        Dream *item = (Dream *)listItem;
        [self goDream:item.id];
    }];
    
    return listViewController;
}

- (UIViewController*)setupDreamsDoneViewController {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager flybooklist:self.userId isdone:1 pager:pager success:^(NSInteger total, NSArray<BasicUser> *users) {
            callback(total, users);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[DreamCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        DreamCell *itemCell = (DreamCell *)cell;
        Dream *item = (Dream *)listItem;
        [itemCell initUIWith:item andAppearence:isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        Dream *item = (Dream *)listItem;
        [self goDream:item.id];
    }];
    
    return listViewController;
}

- (UIViewController*)setupPostsViewController {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager postlist:self.userId pager:pager success:^(NSInteger total, NSArray<Post> *posts) {
            callback(total, posts);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[PostCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        PostCell *itemCell = (PostCell *)cell;
        Post *item = (Post *)listItem;
        [itemCell initUIWith:item andAppearence:isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        Post *item = (Post *)listItem;
        [self goPost:item.id];
    }];
    
    return listViewController;
}

- (void)needUpdateTabs:(UIViewController *)sender {
    [ApiDataManager flybook:self.userId success:^(Flybook *flybook_) {
        flybook = flybook_;
        
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
                    if ([vc isKindOfClass:[DreambookProfileViewController class]]) {
                        DreambookProfileViewController *profileVC = (DreambookProfileViewController *)vc;
                        profileVC.profile = flybook_;
                        [profileVC update];
                    }
                    [newViewControllers setObject:vc forKey:[NSNumber numberWithInteger:newIndexOfTab]];
                    if (vc && [vc conformsToProtocol:@protocol(UpdatableViewControllerDelegate)]) {
                        [((NSObject<UpdatableViewControllerDelegate> *)vc) update];
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

- (void)goDream:(NSInteger)dreamId {
    DreamRootViewController *dreamViewController = [[DreamRootViewController alloc] initWithNibName:@"DreamRootViewController" bundle:nil];
    dreamViewController.dreamId = dreamId;
    [self.navigationController pushViewController:dreamViewController animated:YES];
}

- (void)goEdit {
    EditProfileViewController *editViewController = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    editViewController.tabsDelegate = self;
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)goPhotos {
    ProfilePhotosViewController *photosViewController = [[ProfilePhotosViewController alloc] initWithNibName:@"ProfilePhotosViewController" bundle:nil];
    photosViewController.userId = self.userId;
    [self.navigationController pushViewController:photosViewController animated:YES];
}

//- (void)goProposed {
//    ProposedDreamsViewController *proposedDreamsViewController = [[ProposedDreamsViewController alloc] initWithNibName:@"ProposedDreamsViewController" bundle:nil];
//    proposedDreamsViewController.tabsDelegate = self;
//    [self.navigationController pushViewController:proposedDreamsViewController animated:YES];
//}

- (void)goPost:(NSInteger)postId {
    PostRootViewController *postViewController = [[PostRootViewController alloc] initWithNibName:@"PostRootViewController" bundle:nil];
    postViewController.postId = postId;
    [self.navigationController pushViewController:postViewController animated:YES];
}

- (void)goAddPost {
    PostPostViewController *postPostViewController = [[PostPostViewController alloc] initWithNibName:@"PostPostViewController" bundle:nil];
    postPostViewController.tabsDelegate = self;
    [self.navigationController pushViewController:postPostViewController animated:YES];
}

- (void)requestFriendship:(NSInteger)userId {
    [ApiDataManager requestfriendship:userId success:^{
        [self showAlert:@"Заявка отправлена"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)unfriend:(NSInteger)userId {
    [ApiDataManager unfriend:userId success:^{
        [self showAlert:@"Друг удален"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)denyrequest:(NSInteger)userId {
    [ApiDataManager denyrequest:userId success:^{
        [self showAlert:@"Заявка отклонена"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)subscribe:(NSInteger)userId {
    [ApiDataManager subscribe:userId success:^{
        [self showAlert:@"Вы подписались"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)unsubscribe:(NSInteger)userId {
    [ApiDataManager unsubscribe:userId success:^{
        [self showAlert:@"Подписка отменена"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

@end
