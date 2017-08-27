//
//  PMNewsListVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 13.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMNewsListVC.h"
#import "PMNewsMenuButton.h"
#import "PMButtonWithRighticon.h"

NSString * const kPMStoryboardIDNewsFeedVC = @"NewsFeedVC";
NSString * const kPMStoryboardIDUpdatingVC = @"UpdatingVC";
NSString * const kPMStoryboardIDRecommendationsVC = @"RecommendationsVC";
NSString * const kPMStoryboardIDCommentsVC = @"CommentsVC";

@interface PMNewsListVC ()
@property (weak, nonatomic) IBOutlet UIStackView *menuView;
@property (weak, nonatomic) IBOutlet PMNewsMenuButton *newsFeedButton;
@property (weak, nonatomic) IBOutlet PMNewsMenuButton *updatingButton;
@property (weak, nonatomic) IBOutlet PMNewsMenuButton *recommendationsButton;
@property (weak, nonatomic) IBOutlet PMNewsMenuButton *commentsButton;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) PMButtonWithRightIcon *titleButton;
@property (weak, nonatomic) UIViewController *containerVC;
@end

@implementation PMNewsListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupLocalization];
}

- (void)setupUI
{
    [self buildTitleButton];
    self.newsFeedButton.type = PMNewsMenuTypeNewsFeed;
    self.updatingButton.type = PMNewsMenuTypeUpdating;
    self.recommendationsButton.type = PMNewsMenuTypeRecommendations;
    self.commentsButton.type = PMNewsMenuTypeComments;
    
    [self setupContainerVCWithMenuType:PMNewsMenuTypeNewsFeed];
}

- (void)setupLocalization
{
    [self.newsFeedButton setTitle:NSLocalizedString(@"news.news_list.news_feed_title", nil) forState:UIControlStateNormal];
    [self.updatingButton setTitle:NSLocalizedString(@"news.news_list.updating_title", nil) forState:UIControlStateNormal];
    [self.recommendationsButton setTitle:NSLocalizedString(@"news.news_list.recommendations_title", nil) forState:UIControlStateNormal];
    [self.commentsButton setTitle:NSLocalizedString(@"news.news_list.comments_title", nil) forState:UIControlStateNormal];
}

- (IBAction)changeContainerView:(PMNewsMenuButton *)button
{
    if (self.containerVC) {
        [self.containerVC.view removeFromSuperview];
        [self.containerVC removeFromParentViewController];
    }
    [self setupContainerVCWithMenuType:button.type];
    self.menuView.hidden = YES;
    self.titleButton.isInverted = NO;
}

- (void)setupContainerVCWithMenuType:(PMNewsMenuType)type
{
    UIViewController *childVC;
    switch (type) {
        case PMNewsMenuTypeNewsFeed:
            childVC = [self.storyboard instantiateViewControllerWithIdentifier:kPMStoryboardIDNewsFeedVC];
            [self.titleButton setTitle:[NSLocalizedString(@"news.news_list.news_title", nil) uppercaseString] forState:UIControlStateNormal];
            break;
        case PMNewsMenuTypeUpdating:
            childVC = [self.storyboard instantiateViewControllerWithIdentifier:kPMStoryboardIDUpdatingVC];
              [self.titleButton setTitle:[NSLocalizedString(@"news.news_list.updating_title", nil) uppercaseString] forState:UIControlStateNormal];
            break;
        case PMNewsMenuTypeRecommendations:
            childVC = [self.storyboard instantiateViewControllerWithIdentifier:kPMStoryboardIDRecommendationsVC];
            [self.titleButton setTitle:[NSLocalizedString(@"news.news_list.recommendations_title", nil) uppercaseString] forState:UIControlStateNormal];
            break;
        case PMNewsMenuTypeComments:
            childVC = [self.storyboard instantiateViewControllerWithIdentifier:kPMStoryboardIDCommentsVC];
            [self.titleButton setTitle:[NSLocalizedString(@"news.news_list.comments_title", nil) uppercaseString] forState:UIControlStateNormal];
            break;
        default:
            return;
    }
    
    [self addChildViewController:childVC];
    [childVC didMoveToParentViewController:self];
    [self.containerView addSubview:childVC.view];
    self.containerVC = childVC;
    
    @weakify(self);
    [childVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.containerView);
    }];
}

- (void)buildTitleButton
{
    PMButtonWithRightIcon *titleButton = [PMButtonWithRightIcon buttonWithType:UIButtonTypeCustom];
    [titleButton setTitle:[NSLocalizedString(@"news.news_list.news_title", nil) uppercaseString] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"menu_arrow"] forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"menu_arrow"]  forState:UIControlStateHighlighted];
    [titleButton addTarget:self action:@selector(changeMenuState) forControlEvents:UIControlEventTouchUpInside];
    self.titleButton = titleButton;
    self.navigationItem.titleView = titleButton;
}

- (void)changeMenuState
{
    self.titleButton.isInverted = self.menuView.hidden;
    self.menuView.hidden = !self.menuView.hidden;
    if (!self.menuView.hidden) {
        [self.view bringSubviewToFront:self.menuView];
    }
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
