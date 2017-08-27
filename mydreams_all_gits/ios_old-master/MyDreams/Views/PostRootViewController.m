//
//  PostRootViewController.m
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "MDTabBarViewController.h"
#import "PostRootViewController.h"
#import "CommonListViewController.h"
#import "PostMainViewController.h"
#import "PostCommentsViewController.h"
#import "PostPostViewController.h"
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
#import "Constants.h"
#import "UIHelpers.h"

@interface PostRootViewController ()

@end

@implementation PostRootViewController {
    Post *post;
    NSDictionary *tabIndexes;
    MDTabBarViewController *tabBarViewController;
    BOOL isSelf;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self performLoading];
}

- (AppearenceStyle)appearenceStyle {
    BOOL isVip = isSelf ? [Helper profileIsVip] : (post.owner ? post.owner.isVip : NO);
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return 2;
}

- (NSArray *)setupAlertActions {
    if (!isSelf) {
        return nil;
    }
    
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    if (!isSelf) {
    }
    else {
        UIAlertAction *editAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_DREAM_EDIT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self goEdit];
        }];
        [alertActions addObject:editAction];
    }
    
    return alertActions;
}

- (void)performLoading {
    [ApiDataManager post:self.postId success:^(Post *post_) {
        post = post_;
        isSelf = post.owner.id == [Helper profileUserId];
        
        self.title = post.title;
        [self setupTabs];
        [self setupContextMenu];
        [self setupAppearence];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)needUpdateTabs:(UIViewController *)sender {
    [ApiDataManager post:self.postId success:^(Post *post_) {
        post = post_;
        isSelf = post.owner.id == [Helper profileUserId];
        
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
    
    if ([post.likes longValue] > 0) {
        [items addObject:[Helper localizedStringWithDeclension:@"_LIKES_DECLENSION"
                                                        number:[post.likes longValue]]];
        [tabIndexes_ setObject:@"likes" forKey:[NSNumber numberWithUnsignedLong:[tabIndexes_ count]]];
    }
    [items addObject:[Helper localizedStringWithDeclension:@"_COMMENTS_DECLENSION"
                                                    number:[post.comments longValue]]];
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
    else if ([tabName isEqualToString:@"comments"]) {
        return [self setupCommentsTabContent];
    }
    
    return [self setupMainTabContent];
}

- (UIViewController *)setupMainTabContent {
    PostMainViewController *postMainViewController = [[PostMainViewController alloc] initWithNibName:@"PostMainViewController" bundle:nil];
    postMainViewController.post = post;
    postMainViewController.delegate = self;
    return postMainViewController;
}

- (UIViewController *)setupLikesTabContent {
    CommonListViewController *listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager postlikes:post.id pager:pager success:^(NSInteger total, NSArray<DreamLike> *items) {
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
        [self goFlybook:item.user.id];
    }];
    
    return listViewController;
}

- (UIViewController *)setupCommentsTabContent {
    PostCommentsViewController *commentsViewController = [[PostCommentsViewController alloc] initWithNibName:@"PostCommentsViewController" bundle:nil];
    commentsViewController.postId = post.id;
    commentsViewController.delegate = self;
    return commentsViewController;
}

- (void)goFlybook:(NSInteger)userId {
    DreambookRootViewController *dreambookViewController = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    dreambookViewController.userId = userId;
    [self.navigationController pushViewController:dreambookViewController animated:YES];
}

- (void)goEdit {
    PostPostViewController *postPostViewController = [[PostPostViewController alloc] initWithNibName:@"PostPostViewController" bundle:nil];
    postPostViewController.editedPostId = self.postId;
    [self.navigationController pushViewController:postPostViewController animated:YES];
}

@end
