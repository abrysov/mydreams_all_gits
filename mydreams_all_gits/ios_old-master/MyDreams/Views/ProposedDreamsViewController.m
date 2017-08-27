//
//  ProposedDreamsViewController.m
//  MyDreams
//
//  Created by Игорь on 28.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "ProposedDreamsViewController.h"
#import "CommonListViewController.h"
#import "Helper.h"
#import "ProposedDreamCell.h"
#import "DreamRootViewController.h"

@interface ProposedDreamsViewController ()

@end

@implementation ProposedDreamsViewController {
    CommonListViewController *listViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CommonListViewController *vc = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    listViewController = vc;
    
    self.title = [Helper localizedString:@"_PROPOSED_TITLE"];
    
    [self setup];
}

- (AppearenceStyle)appearenceStyle {
    BOOL isVip = [Helper profileIsVip];
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return 2;
}

-(BOOL)isSectionRoot {
    return NO;
}

- (void)setup {
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager proposed:pager success:^(NSInteger total, NSArray<Dream> *dreams) {
            callback(total, dreams);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:([ProposedDreamCell class]) andCellInitializer:^(UITableViewCell *cell, id listItem) {
        ProposedDreamCell *itemCell = (ProposedDreamCell *)cell;
        Dream *item = (Dream *)listItem;
        [itemCell initUIWith:item andAppearence:AppearenceStyleNONE];
        itemCell.deleteCellDelegate = self;
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        Dream *item = (Dream *)listItem;
        [self goDream:item.id];
    }];
    [self present];
}

- (void)deleteCell:(UITableViewCell *)cell {
    [listViewController deleteCell:cell];
    [self.tabsDelegate needUpdateTabs:self];
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
