//
//  PMApplicationRouterImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMApplicationRouterImpl.h"
#import <RESideMenu/RESideMenu.h>
#import "PMMenuVC.h"
#import "MenuSegues.h"

NSString * const kPMApplicationRouterAuthentificationStoryboard = @"Authentification";
NSString * const kPMApplicationRouterMainStoryboard = @"Main";

@implementation PMApplicationRouterImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.selectedMenuItem = PMMenuItemNews;
    }
    return self;
}

- (void)openURL:(NSURL *)url
{
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)openAuthVC
{
    [self openRootVCFromStoryBoard:kPMApplicationRouterAuthentificationStoryboard];
}

- (void)openUserBlockedVC
{
    UIStoryboard *stroryBoard = [UIStoryboard storyboardWithName:kPMApplicationRouterAuthentificationStoryboard bundle:nil];
    UINavigationController *navigationController = [stroryBoard instantiateInitialViewController];
    [navigationController pushViewController:[stroryBoard instantiateViewControllerWithIdentifier:@"PMBlockedProfileVC"] animated:NO];
    self.window.rootViewController = navigationController;
}

- (void)openUserDeletedVC
{
    UIStoryboard *stroryBoard = [UIStoryboard storyboardWithName:kPMApplicationRouterAuthentificationStoryboard bundle:nil];
    UINavigationController *navigationController = [stroryBoard instantiateInitialViewController];
    [navigationController pushViewController:[stroryBoard instantiateViewControllerWithIdentifier:@"PMRestoreProfileVC"] animated:NO];
    self.window.rootViewController = navigationController;
}

- (void)openMainVC
{
    [self openRootVCFromStoryBoard:kPMApplicationRouterMainStoryboard];
}

- (void)openMenuItem:(PMMenuItem)menuItem
{
    RESideMenu *sideMenu = (RESideMenu *)self.window.rootViewController;
    PMMenuVC *menuVC = (PMMenuVC *)sideMenu.leftMenuViewController;
    [menuVC performSegueWithIdentifier:[self segueIdentifierForMenuItem:menuItem] sender:nil];
    
    self.selectedMenuItem = menuItem;
}

#pragma mark - private

- (void)openVCWithIdentifier:(NSString *)identifier fromStoryBoard:(NSString *)storyboard
{
    UIStoryboard *stroryBoard = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UIViewController *vc = [stroryBoard instantiateViewControllerWithIdentifier:identifier];
    self.window.rootViewController = vc;
}

- (void)openRootVCFromStoryBoard:(NSString *)storyboard
{
    UIStoryboard *stroryBoard = [UIStoryboard storyboardWithName:storyboard bundle:nil];
    UIViewController *vc = [stroryBoard instantiateInitialViewController];
    self.window.rootViewController = vc;
}

- (NSString *)segueIdentifierForMenuItem:(PMMenuItem) menuItem {
    switch (menuItem) {
        case PMMenuItemMyDreambook:
            return kPMSegueIdentifierMenuToDreambookVC;
        case PMMenuItemMessages:
            return kPMSegueIdentifierMenuToListConversationsVC;
        case PMMenuItemEvents:
            return kPMSegueIdentifierMenuToNewsListVC;
        case PMMenuItemNews:
            return kPMSegueIdentifierMenuToNewsListVC;
        case PMMenuItemFulfillDream:
            return kPMSegueIdentifierMenuToFulfillDreamVC;
        case PMMenuItemFulfilledDreams:
            return kPMSegueIdentifierMenuToFulfilledListDreamsVC;
        case PMMenuItemDreams:
            return kPMSegueIdentifierMenuToListDreamsVC;
        case PMMenuItemTop100:
            return kPMSegueIdentifierMenuToTop100DreamsVC;
        case PMMenuItemDreamers:
            return kPMSegueIdentifierMenuToListDreamersVC;
        case PMMenuItemClubDreams:
            return kPMSegueIdentifierMenuToDreamclubVC;
        case PMMenuItemSettings:
            return kPMSegueIdentifierMenuToSettingsVC;
        case PMMenuItemSearch:
            return kPMSegueIdentifierMenuToSearchVC;
    }
}

@end
