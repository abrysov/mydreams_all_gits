//
//  MenuDialogViewController.m
//  Unicom
//
//  Created by Игорь on 28.06.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "MyDreamsNavigationController.h"
#import "SWRevealViewController.h"
#import "MenuDialogViewController.h"
#import "FriendsViewController.h"
#import "PostDreamViewController.h"
#import "EditProfileViewController.h"
#import "TopDreamsViewController.h"
#import "EventFeedViewController.h"
#import "UserListViewController.h"
#import "DreambookRootViewController.h"
#import "Helper.h"
#import "Constants.h"

@interface MenuDialogViewController ()
@end

@implementation MenuDialogViewController {
    NSInteger activeMenuItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTouchEvent:self.rootView];
    [self initTouchEvent:self.menuPanel];
    [self initTouchEvent:self.addDreamItemView];
    [self initTouchEvent:self.flybookItemView];
    [self initTouchEvent:self.friendsItemView];
    [self initTouchEvent:self.newsItemView];
    [self initTouchEvent:self.topItemView];
    [self initTouchEvent:self.dreamersItemView];
}

- (void)initUI {
    self.fullnameLabel.text = [Helper profileFullname];
    self.emailLabel.text = [Helper profileEmail];
    [self.avatarImageView.layer setCornerRadius:25];
    [Helper setImageView:self.avatarImageView withImageUrl:[Helper profileAvatarUrl] andDefault:@"_LOGO_IMAGE_BLUE"];
    
    BOOL isVip = [Helper profileIsVip];
    self.flybookItemPlankView.backgroundColor = [Helper colorWithHexString:(isVip ? COLOR_STYLE_PURPLE : COLOR_STYLE_BLUE)];
    self.headerBackgroundImageView.image = [UIImage imageNamed:(isVip ? @"dummy-purple.png" : @"dummy-blue")];
    self.headerBackgroundView.backgroundColor = [Helper colorWithHexString:(isVip ? COLOR_STYLE_PURPLE : COLOR_STYLE_BLUE)];
    
    [self setupMenu];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        [self initUI];
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position {
    if (position == FrontViewPositionRight) {
        //[self.view addGestureRecognizer:revealController.panGestureRecognizer];
    }
    else if (position == FrontViewPositionLeft) {
        //[self.view removeGestureRecognizer:revealController.panGestureRecognizer];
    }
}

- (void)initProfileInfo {
    
}

- (void)initTouchEvent:(UIView *)view {
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [view addGestureRecognizer:singleFingerTap];
    view.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    UINavigationController *navigationController = (UINavigationController *)self.presentingViewController;
    if ([navigationController class] == [UITabBarController class]) {
        navigationController = (UINavigationController *)((UITabBarController *)navigationController).selectedViewController;
    }
    
    if (recognizer.view == self.rootView) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
//    else if (recognizer.view == self.menuIconView) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
    else if (recognizer.view == self.menuPanel) {
    }
    else if (recognizer.view == self.addDreamItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goAddDream];
    }
    else if (recognizer.view == self.flybookItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goDreambook];
    }
    else if (recognizer.view == self.friendsItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goFriends];
    }
    else if (recognizer.view == self.newsItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goEventFeed];
    }
    else if (recognizer.view == self.topItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goTopDreams];
    }
    else if (recognizer.view == self.dreamersItemView) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [self goUserSearch];
    }
}

- (UINavigationController *)navigationControllerCurrent {
    return (MyDreamsNavigationController *)self.revealViewController.frontViewController;
}

- (void)goFriends {
    FriendsViewController *vc = [[FriendsViewController alloc] initWithNibName:@"FriendsViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goDreambook {
    DreambookRootViewController *vc = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goEditProfile {
    EditProfileViewController *vc = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goAddDream {
    PostDreamViewController *vc = [[PostDreamViewController alloc] initWithNibName:@"PostDreamViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goTopDreams {
    TopDreamsViewController *vc = [[TopDreamsViewController alloc] initWithNibName:@"TopDreamsViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goEventFeed {
    EventFeedViewController *vc = [[EventFeedViewController alloc] initWithNibName:@"EventFeedViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)goUserSearch {
    UserListViewController *vc = [[UserListViewController alloc] initWithNibName:@"UserListViewController" bundle:nil];
    [self.navigationControllerCurrent pushViewController:vc animated:NO];
    [self.revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    [self setActiveMenuItem:[vc activeMenuItem]];
    [self setupMenu];
}

- (void)setActiveMenuItem:(NSInteger)menuIndex {
    activeMenuItem = menuIndex;
}

- (void)setupMenu {
    switch (activeMenuItem) {
        case 1:
            [self setActiveMenu:self.addDreamItemView];
            break;
            
        case 2:
            [self setActiveMenu:self.flybookItemView];
            break;
            
        case 3:
            [self setActiveMenu:self.friendsItemView];
            break;
            
        case 4:
            [self setActiveMenu:self.newsItemView];
            break;
            
        case 5:
            [self setActiveMenu:self.topItemView];
            break;
            
        case 6:
            [self setActiveMenu:self.dreamersItemView];
            break;
            
        default:
            [self setActiveMenu:nil];
            break;
    }
}

- (void)setActiveMenu:(UIView *)menuItem {
    self.friendsItemView.backgroundColor = [UIColor whiteColor];
    self.addDreamItemView.backgroundColor = [UIColor whiteColor];
    self.flybookItemView.backgroundColor = [UIColor whiteColor];
    self.topItemView.backgroundColor = [UIColor whiteColor];
    self.newsItemView.backgroundColor = [UIColor whiteColor];
    self.dreamersItemView.backgroundColor = [UIColor whiteColor];
    
    UIColor *textColor = [Helper colorWithHexString:@"#4d4d4d"];
    
    self.friendsItemLabel.textColor = textColor;
    self.addDreamItemLabel.textColor = textColor;
    self.flybookItemLabel.textColor = textColor;
    self.topItemLabel.textColor = textColor;
    self.newsItemLabel.textColor = textColor;
    self.dreamersItemLabel.textColor = textColor;
    
    if (menuItem == self.friendsItemView) {
        menuItem.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_DBLUE];
        self.friendsItemLabel.textColor = [UIColor whiteColor];
    }
    else if (menuItem == self.addDreamItemView) {
        menuItem.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_GREEN];
        self.addDreamItemLabel.textColor = [UIColor whiteColor];
    }
    else if (menuItem == self.flybookItemView) {
        BOOL isVip = [Helper profileIsVip];
        menuItem.backgroundColor = [Helper colorWithHexString:(isVip ? COLOR_STYLE_PURPLE : COLOR_STYLE_BLUE)];
        self.flybookItemLabel.textColor = [UIColor whiteColor];
    }
    else if (menuItem == self.topItemView) {
        menuItem.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_YELLOW];
        self.topItemLabel.textColor = [UIColor whiteColor];
    }
    else if (menuItem == self.newsItemView) {
        menuItem.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_RED];
        self.newsItemLabel.textColor = [UIColor whiteColor];
    }
    else if (menuItem == self.dreamersItemView) {
        menuItem.backgroundColor = [Helper colorWithHexString:COLOR_STYLE_VIRID];
        self.dreamersItemLabel.textColor = [UIColor whiteColor];
    }
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.presenting) {
        MenuDialogViewController* menuViewController = ((MenuDialogViewController *)toViewController);
        
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:menuViewController.view];
        
        CGRect endFrame = menuViewController.menuPanel.frame;
        CGRect startFrame = endFrame;
        startFrame.origin.x -= endFrame.size.width;
        menuViewController.menuPanel.frame = startFrame;
        menuViewController.view.frame = fromViewController.view.frame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
            menuViewController.menuPanel.frame = endFrame;
            menuViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        MenuDialogViewController* menuViewController = ((MenuDialogViewController *)fromViewController);
        
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:menuViewController.view];
        
        CGRect endFrame = menuViewController.menuPanel.frame;
        endFrame.origin.x -= endFrame.size.width;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
            menuViewController.menuPanel.frame = endFrame;
            menuViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
