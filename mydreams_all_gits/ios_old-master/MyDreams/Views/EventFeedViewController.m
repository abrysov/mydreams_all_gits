//
//  EventFeedViewController.m
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "EventFeedViewController.h"
#import "CommonListViewController.h"
#import "EventFeed.h"
#import "EventFeedCommentCell.h"
#import "EventFeedPhotosCell.h"
#import "ApiDataManager.h"
#import "DreamRootViewController.h"
#import "DreambookRootViewController.h"
#import "ProfilePhotosViewController.h"

@interface EventFeedViewController ()

@end

@implementation EventFeedViewController {
    CommonListViewController *listViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommonListViewController *vc = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    listViewController = vc;
    
    self.title = @"Лента активности";
    
    [self setup];
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStyleRED;
}

- (NSInteger)activeMenuItem {
    return 4;
}

- (BOOL)isSectionRoot {
    return YES;
}

- (void)setup {
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager eventfeed:pager success:^(NSInteger total, NSArray<EventFeedItem> *dreams) {
            callback(total, dreams);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:([EventFeedPhotosCell class]) andCellInitializer:^(UITableViewCell *cell, id listItem) {
        EventFeedPhotosCell *itemCell = (EventFeedPhotosCell *)cell;
        EventFeedItem *item = (EventFeedItem *)listItem;
        [itemCell initUIWith:item];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        EventFeedItem *item = (EventFeedItem *)listItem;
        if (item.photos) {
            [self goFlybookPhotos:item.user.id];
        }
        else {
            [self goFlybook:item.user.id];
        }
    }];
    [self present];
}

- (void)present {
    [self addChildViewController:listViewController];
    listViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:listViewController.view];
    [listViewController didMoveToParentViewController:self];
}

- (void)goDream:(NSInteger)dreamId {
    DreamRootViewController *dreamViewController = [[DreamRootViewController alloc] initWithNibName:@"DreamRootViewController" bundle:nil];
    dreamViewController.dreamId = dreamId;
    [self.navigationController pushViewController:dreamViewController animated:YES];
}

- (void)goFlybook:(NSInteger)userId {
    DreambookRootViewController *dreambookViewController = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    dreambookViewController.userId = userId;
    [self.navigationController pushViewController:dreambookViewController animated:YES];
}

- (void)goFlybookPhotos:(NSInteger)userId {
    ProfilePhotosViewController *photosViewController = [[ProfilePhotosViewController alloc] initWithNibName:@"ProfilePhotosViewController" bundle:nil];
    photosViewController.userId = userId;
    [self.navigationController pushViewController:photosViewController animated:YES];
}

@end
