//
//  TopDreamsViewController.m
//  MyDreams
//
//  Created by Игорь on 16.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "TopDreamsViewController.h"
#import "ApiDataManager.h"
#import "Constants.h"
#import "Dream.h"
#import "CommonListViewController.h"
#import "TopDreamCell.h"
#import "DreamRootViewController.h"
#import "Helper.h"

@interface TopDreamsViewController ()

@end

@implementation TopDreamsViewController {
    CommonListViewController *listViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommonListViewController *vc = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    listViewController = vc;
    
    self.title = @"Топ-100";
    
    [self setup];
}

- (AppearenceStyle)appearenceStyle {
    return AppearenceStyleYELLOW;
}

- (NSInteger)activeMenuItem {
    return 5;
}

-(BOOL)isSectionRoot {
    return YES;
}

- (void)setup {
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager top:pager success:^(NSInteger total, NSArray<Dream> *dreams) {
            callback(total, dreams);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:([TopDreamCell class]) andCellInitializer:^(UITableViewCell *cell, id listItem) {
        TopDreamCell *itemCell = (TopDreamCell *)cell;
        Dream *item = (Dream *)listItem;
        [itemCell initUIWith:item andAppearence:AppearenceStyleNONE];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        Dream *item = (Dream *)listItem;
        [self goDream:item.id];
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

@end
