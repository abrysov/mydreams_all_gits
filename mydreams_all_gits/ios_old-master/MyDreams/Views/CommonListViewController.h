//
//  CommonListViewController.h
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiDataManager.h"
#import "BaseViewController.h"

typedef void (^CommonListRetreiveCallbackBlock)(NSInteger total, NSArray *items);
typedef void (^CommonListRetreiverBlock)(Pager *, CommonListRetreiveCallbackBlock);
typedef void (^CellInitializer)(UITableViewCell *, id listItem);
typedef NSString *(^SectionNameBlock)(id listItem);
typedef void (^CommonListSelectItemBlock)(id listItem);


@class CommonListViewController;

@protocol CommonListViewControllerDelegate

//- (void)listItemsRetrieved:(CommonListViewController *)controller total:(NSInteger)total items:(NSArray *)items;
- (void)retrieveListItems:(CommonListViewController *)controller pager:(Pager *)pager callback:(CommonListRetreiveCallbackBlock)callback;
- (void)setupCell:(CommonListViewController *)controller cell:(UITableViewCell *)cell listItem:(id)listItem;
- (NSString *)sectionName:(id)listItem;

@end

@interface CommonListViewController : UIViewController<UpdatableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTable;

@property (weak, nonatomic) id<CommonListViewControllerDelegate> listDelegate;

//- (void)setupWithDelegate:(id)delegate andCellType:(Class)cellType;

- (void)initWithRetreiver:(CommonListRetreiverBlock)retreiver andCellType:(Class)cellType andCellInitializer:(CellInitializer)cellInitializer andSectionNameDelegate:(SectionNameBlock)sectionNameDelegate andSelectItem:(CommonListSelectItemBlock)selectItem;

- (void)reload;

- (void)deleteCell:(UITableViewCell *)cell;

@end
