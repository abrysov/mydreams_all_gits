//
//  PMContainerController.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFastLinksContainerController.h"
#import <Masonry/Masonry.h>
#import "PMFastLinkItemView.h"
#import "PMFastLinksLogic.h"
#import "UIColor+MyDreams.h"

@interface PMFastLinksContainerController () <PMFastLinkItemViewDelegate>
@property (strong, nonatomic) PMFastLinksLogic *logic;

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *tabBarContainer;

@property (weak, nonatomic) IBOutlet PMFastLinkItemView *newsFastLinkItem;
@property (weak, nonatomic) IBOutlet PMFastLinkItemView *eventsFastLinkItem;
@property (weak, nonatomic) IBOutlet PMFastLinkItemView *messagesFastLinkItem;
@property (weak, nonatomic) IBOutlet PMFastLinkItemView *searchFastLinkItem;

@property (strong, nonatomic) NSArray<PMFastLinkItemView *> *fastLinkItemViewArray;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstaraintToBottomLayoutGuide;
@end

@implementation PMFastLinksContainerController
@dynamic logic;

#pragma mark - View lifecycle

- (void)setupUI
{
    [super setupUI];
    
    if (self.contentViewStoryboardID) {
        self.controller = [self.storyboard instantiateViewControllerWithIdentifier:self.contentViewStoryboardID];
    }
    
    self.fastLinkItemViewArray = @[self.newsFastLinkItem,
                                   self.eventsFastLinkItem,
                                   self.messagesFastLinkItem,
                                   self.searchFastLinkItem];
    
    self.newsFastLinkItem.menuItem = PMMenuItemNews;
    self.eventsFastLinkItem.menuItem = PMMenuItemEvents;
    self.messagesFastLinkItem.menuItem = PMMenuItemMessages;
    self.searchFastLinkItem.menuItem = PMMenuItemSearch;
    
    [self setFastlLinksDelegate];
    
    self.underTabBar = NO;
    self.style = PMFastLinksContainerControllerStyleLight;
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.newsFastLinkItem.title = NSLocalizedString(@"fastlink.news", nil);
    self.eventsFastLinkItem.title = NSLocalizedString(@"fastlink.events", nil);
    self.messagesFastLinkItem.title = NSLocalizedString(@"fastlink.messages", nil);
    self.searchFastLinkItem.title = NSLocalizedString(@"fastlink.search", nil);
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    @weakify(self);
    [RACObserve(self.logic, selectedMenuItem)
        subscribeNext:^(NSNumber *selectedMenuItem) {
            @strongify(self);
            PMMenuItem menuItem = (PMMenuItem)[selectedMenuItem unsignedIntegerValue];
            PMFastLinkItemView *itemView = [self itemViewByMenuItem:menuItem];
            [self deselectAllItemsExcept:itemView];
            [itemView select];
        }];
}

#pragma mark - properties

- (void)setUnderTabBar:(BOOL)underTabBar
{
    self->_underTabBar = underTabBar;
    if (underTabBar) {
        self.bottomConstaraintToBottomLayoutGuide.priority = 999;
    }
    else {
        self.bottomConstaraintToBottomLayoutGuide.priority = 900;
    }
    [self.view layoutIfNeeded];
}

- (void)setStyle:(PMFastLinksContainerControllerStyle)style
{
    self->_style = style;
    
    switch (style) {
        case PMFastLinksContainerControllerStyleDark:
            self.tabBarContainer.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];

            for (PMFastLinkItemView *itemView in self.fastLinkItemViewArray) {
                itemView.normalTintColor = [UIColor whiteColor];
                itemView.selectedTintColor = [UIColor settingsActiveButtonColor];
                itemView.textColor = [UIColor whiteColor];
            }
            
            break;
        case PMFastLinksContainerControllerStyleLight:
            self.tabBarContainer.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            
            for (PMFastLinkItemView *itemView in self.fastLinkItemViewArray) {
                itemView.normalTintColor = [UIColor settingsBaseColor];
                itemView.selectedTintColor = [UIColor settingsActiveButtonColor];
                itemView.textColor = [UIColor settingsBaseColor];
            }
            
            break;
    }
}

#pragma mark - public

- (void)setController:(UIViewController *)controller
{
    [self.controller willMoveToParentViewController:nil];
    [self.controller.view removeFromSuperview];
    [self.controller removeFromParentViewController];
    
    self->_controller = controller;
    
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.container addSubview:controller.view];

    [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.container);
    }];
        
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - proxy

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.controller.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return self.controller.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return self.controller.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate
{
    return self.controller.shouldAutorotate;
}

#pragma mark - PMFastLinkItemViewDelegate

- (void)didSelectFastLinkItemView:(PMFastLinkItemView *)item
{
    [self deselectAllItemsExcept:item];
    [self.logic openMenuItem:item.menuItem];
}

#pragma mark - actions

- (IBAction)createDreamButtonHandler:(id)sender
{
    [self deselectAllItemsExcept:nil];
    [self.logic openMenuItem:PMMenuItemFulfillDream];
}

#pragma mark - private

- (void)setFastlLinksDelegate
{
    for (PMFastLinkItemView *itemView in self.fastLinkItemViewArray) {
        itemView.delegate = self;
    }
}

- (void)deselectAllItemsExcept:(PMFastLinkItemView *)item
{
    for (PMFastLinkItemView *itemView in self.fastLinkItemViewArray) {
        if (![itemView isEqual:item]) {
            [itemView deselect];
        }
    }
}

- (PMFastLinkItemView*)itemViewByMenuItem:(PMMenuItem)menuItem
{
    for (PMFastLinkItemView *itemView in self.fastLinkItemViewArray) {
        if (itemView.menuItem == menuItem) {
            return itemView;
        }
    }
    
    return nil;
}

@end

@implementation UIViewController (PMFastLinksContainerController)

- (PMFastLinksContainerController *)fastLinksContainer
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[PMFastLinksContainerController class]]) {
            return (PMFastLinksContainerController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}

@end
