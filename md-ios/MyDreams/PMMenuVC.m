//
//  PMMenuVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 15.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMenuVC.h"
#import "PMMenuLogic.h"
#import "PMMenuItem.h"
#import "PMMenuItemView.h"
#import "PMMenuViewModel.h"
#import <RESideMenu/RESideMenu.h>

@interface PMMenuVC () <PMMenuItemViewDelegate, RESideMenuDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *coinsCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *addCreditsButton;
@property (weak, nonatomic) IBOutlet PMMenuItemView *meDreambookMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *messagesMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *eventsMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *newsMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *fulfillingDreamsMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *fulfillDream;
@property (weak, nonatomic) IBOutlet PMMenuItemView *dreamsMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *dreamersMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *top100MenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *clubDreamsMenuItem;
@property (weak, nonatomic) IBOutlet PMMenuItemView *settingsMenuItem;

@property (strong, nonatomic) NSArray *menuItemViewsArray;
@end

@implementation PMMenuVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    
    self.sideMenuViewController.delegate = self;
    
    self.meDreambookMenuItem.menuItem = PMMenuItemMyDreambook;
    self.messagesMenuItem.menuItem = PMMenuItemMessages;
    self.eventsMenuItem.menuItem = PMMenuItemEvents;
    self.newsMenuItem.menuItem = PMMenuItemNews;
    self.fulfillDream.menuItem = PMMenuItemFulfillDream;
    self.fulfillingDreamsMenuItem.menuItem = PMMenuItemFulfilledDreams;
    self.dreamsMenuItem.menuItem = PMMenuItemDreams;
    self.dreamersMenuItem.menuItem = PMMenuItemDreamers;
    self.top100MenuItem.menuItem = PMMenuItemTop100;
    self.clubDreamsMenuItem.menuItem = PMMenuItemClubDreams;
    self.settingsMenuItem.menuItem = PMMenuItemSettings;
    
    self.menuItemViewsArray = @[self.meDreambookMenuItem,
                                self.messagesMenuItem,
                                self.eventsMenuItem,
                                self.newsMenuItem,
                                self.fulfillingDreamsMenuItem,
                                self.fulfillDream,
                                self.dreamsMenuItem,
                                self.dreamersMenuItem,
                                self.top100MenuItem,
                                self.clubDreamsMenuItem,
                                self.settingsMenuItem];
    
    for (PMMenuItemView *menuItemView in self.menuItemViewsArray) {
        menuItemView.delegate = self;
    }
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    RAC(self.fullnameLabel, text) = RACObserve(self.logic, viewModel.fullName);
    RAC(self.coinsCountLabel, text) = RACObserve(self.logic, viewModel.coinsCount);
    RAC(self.messagesMenuItem, bage) = RACObserve(self.logic, viewModel.messagesCount);
    RAC(self.eventsMenuItem, bage) = RACObserve(self.logic, viewModel.notificationsCount);
    RAC(self.avatarImageView, image) = RACObserve(self.logic, viewModel.avatar);
    
    @weakify(self);
    [RACObserve(self.logic, selectedMenuItem)
        subscribeNext:^(NSNumber *selectedMenuItem) {
            @strongify(self);
            PMMenuItem menuItem = (PMMenuItem)[selectedMenuItem unsignedIntegerValue];
            PMMenuItemView *menuItemView = [self menuItemViewByMenuItem:menuItem];
            [self deselectMenuItemViews];
            [menuItemView select];
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    [self.addCreditsButton setTitle:NSLocalizedString(@"menu.menu.self.add_credits", nil) forState:UIControlStateNormal];
    self.meDreambookMenuItem.title = [NSLocalizedString(@"menu.menu.self.my_dreambook" , nil) uppercaseString];
    self.messagesMenuItem.title = [NSLocalizedString(@"menu.menu.self.messages", nil) uppercaseString];
    self.eventsMenuItem.title = [NSLocalizedString(@"menu.menu.self.events" , nil) uppercaseString];
    self.newsMenuItem.title = [NSLocalizedString(@"menu.menu.self.news", nil) uppercaseString];
    self.fulfillDream.title = [NSLocalizedString(@"menu.menu.self.fulfill_dream", nil) uppercaseString];
    self.fulfillingDreamsMenuItem.title = [NSLocalizedString(@"menu.menu.self.fulfilling_dreams", nil) uppercaseString];
    self.dreamsMenuItem.title = [NSLocalizedString(@"menu.menu.self.dreams", nil) uppercaseString];
    self.dreamersMenuItem.title = [NSLocalizedString(@"menu.menu.self.dreamers", nil) uppercaseString];
    self.top100MenuItem.title = [NSLocalizedString(@"menu.menu.self.top100", nil) uppercaseString];
    self.clubDreamsMenuItem.title = [NSLocalizedString(@"menu.menu.self.club_dreams", nil) uppercaseString];
    self.settingsMenuItem.title = [NSLocalizedString(@"menu.menu.self.settings", nil) uppercaseString];
}

#pragma mark - RESideMenuDelegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController;
{
    if (menuViewController == self) {
        [self.logic.loadProfileCommand execute:self];
    }
}

#pragma mark - PMMenuItemViewDelegate

- (void)didSelectItem:(PMMenuItemView *)item
{
    [self.logic openMenuItem:item.menuItem];
}

#pragma mark - private

- (PMMenuItemView *)menuItemViewByMenuItem:(PMMenuItem)menuItem
{
    for (PMMenuItemView *menuItemView in self.menuItemViewsArray) {
        if (menuItemView.menuItem == menuItem) {
            return menuItemView;
        }
    }
    
    return nil;
}

- (void)deselectMenuItemViews
{
    for (PMMenuItemView *menuItemView in self.menuItemViewsArray) {
        [menuItemView deselect];
    }
}

@end
