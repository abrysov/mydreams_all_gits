//
//  CommonListViewController.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h>
#import <SVPullToRefresh/UIScrollView+SVPullToRefresh.h>
#import "CommonListViewController.h"
#import "ApiDataManager.h"
#import "UserListSectionHeaderCell.h"

@interface CommonListViewController ()
@end

@implementation CommonListViewController {
    Pager *listPager;
    NSInteger totalListItems;
    NSMutableArray *listItems;
    NSArray *listSections;
    NSDictionary *listItemsBySections;
    CommonListRetreiverBlock listRetreiver;
    Class listCellType;
    CellInitializer listCellInitializer;
    SectionNameBlock sectionNameDelegate;
    CommonListSelectItemBlock selectItem;
    NSMutableDictionary *cellHeights;
    BOOL loaded;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect frame = CGRectMake(0.0f, 0.0f, self.listTable.bounds.size.width, 8.0f);
    self.listTable.tableFooterView = [[UIView alloc] initWithFrame:frame];
    self.listTable.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    self.listTable.rowHeight = UITableViewAutomaticDimension;
    self.listTable.estimatedRowHeight = UITableViewAutomaticDimension;
    self.listTable.separatorColor = [UIColor clearColor];
    
    [self setupInfiniteScroll];
    
    [self reload];
}

- (void)setupInfiniteScroll {
//    self.listTable.infiniteScrollingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    [self.listTable addInfiniteScrollingWithActionHandler:^{
//        listPager.page += 1;
//        [self performLoading];
//    }];

    [self.listTable addPullToRefreshWithActionHandler:^{
        [self reload];
    }];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view setColor:[UIColor grayColor]];
    [view startAnimating];
    [self.listTable.pullToRefreshView setCustomView:view forState:SVPullToRefreshStateAll];
}

- (void)reload {
    totalListItems = -1;
    listItems = [[NSMutableArray alloc] init];
    listPager = [[Pager alloc] initWith:1 onpage:5];
    cellHeights = [[NSMutableDictionary alloc] init];
    [self generateSections];
    [self.listTable reloadData];
    [self performLoading];
    [self.listTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

- (void)update {
    [self reload];
}

- (void)generateSections {
    // разбить список по секциям в таблице
    NSMutableDictionary *itemsBySections = [[NSMutableDictionary alloc] init];
    NSMutableArray *sections = [[NSMutableArray alloc] init];
    NSString *prevSectionName;
    NSString *sectionKey;
    for(int i = 0; i < listItems.count; i++) {
        id item = [listItems objectAtIndex:i];
        NSString *sectionName = sectionNameDelegate ? sectionNameDelegate(item) : @"";
        if ([sectionName isEqualToString:prevSectionName]) {
            // та же секция
        }
        else {
            // добавляем новую секцию
            sectionKey = [NSString stringWithFormat:@"%ld", (long)[sections count]];
            [itemsBySections setObject:[[NSMutableArray alloc] init] forKey:sectionKey];
            [sections addObject:sectionName];
        }
        NSMutableArray *sectionItems = (NSMutableArray *)[itemsBySections objectForKey:sectionKey];
        [sectionItems addObject:item];
        prevSectionName = sectionName;
    }
    
    listItemsBySections = itemsBySections;
    listSections = sections;
}

- (NSArray *)listItemsBySection:(NSInteger)section {
    return (NSArray *)[listItemsBySections objectForKey:[NSString stringWithFormat:@"%ld", (long)section]];
}

- (void)initWithRetreiver:(CommonListRetreiverBlock)retreiver
              andCellType:(__unsafe_unretained Class)cellType
       andCellInitializer:(CellInitializer)cellInitializer_
   andSectionNameDelegate:(SectionNameBlock)sectionNameDelegate_
            andSelectItem:(CommonListSelectItemBlock)selectItem_ {
    listRetreiver = retreiver;
    listCellInitializer = cellInitializer_;
    listCellType = cellType;
    sectionNameDelegate = sectionNameDelegate_;
    selectItem = selectItem_;
}

- (void)performLoading {
    listRetreiver(listPager, ^(NSInteger total, NSArray *items) {
        totalListItems = total;
        NSLog(@"%ld items retreived", (unsigned long)items.count);
        if (items.count > 0) {
            
            long start = (listPager.page - 1) * listPager.onpage;
            
            for (long i = 0; i < [items count]; i++) {
                if (start + i < [listItems count]) {
                    listItems[i] = items[i];
                }
                else {
                    [listItems addObject:items[i]];
                }
            }
            
//            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange((listPager.page - 1) * listPager.onpage, [items count])];
//            if ([indexes lastIndex] <= [listItems count]) {
//                [listItems replaceObjectsAtIndexes:indexes withObjects:items];
//            }
//            else {
//                [listItems insertObjects:items atIndexes:indexes];
//            }
            
            [self generateSections];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listTable reloadData];
            });
        }
        else if (listPager.page > 1) {
            // пришел пустой список - декремент страницы, там ничего нет
            listPager.page -= 1;
        }
        else if (listPager.page == 1) {
            // ничего нет даже на первой странице
            [listItems removeAllObjects];
            [self generateSections];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listTable reloadData];
            });
        }
        
        [self.listTable.infiniteScrollingView stopAnimating];
        [self.listTable.pullToRefreshView stopAnimating];
        
        loaded = YES;
    });
}

- (UITableViewCell *)dequeueCell {
    NSString *reuseId = NSStringFromClass(listCellType);
    UITableViewCell *listCell = [self.listTable dequeueReusableCellWithIdentifier:reuseId];
    if (listCell == nil) {
        [self.listTable registerNib:[UINib nibWithNibName:reuseId bundle:nil] forCellReuseIdentifier:reuseId];
        listCell = [self.listTable dequeueReusableCellWithIdentifier:reuseId];
    }
    return listCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *listCell = [self dequeueCell];
    id listItem = [[self listItemsBySection:indexPath.section] objectAtIndex:indexPath.row];
    listCellInitializer(listCell, listItem);
    [self customizeCellForSection:listCell indexPath:indexPath];
    return listCell;
}

- (void)customizeCellForSection:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    //NSArray *sectionItems = [self listItemsBySection:indexPath.section];
    if (indexPath.row == 0) {
        // первая ячейка в секции - надо добавить букву сюда
        UILabel *label = [self labelForSection:indexPath.section];
        [cell addSubview:label];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightAtIndexPath:indexPath];
}

- (CGFloat)cellHeightAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
    NSNumber *height = [cellHeights objectForKey:key];
    return height == nil ? UITableViewAutomaticDimension : [height doubleValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self listItemsBySection:section] count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"path: %@", indexPath);
    if (indexPath.section == [listItemsBySections count] - 1 &&
        indexPath.row == [[self listItemsBySection:indexPath.section] count] - 1) {
        // показывается предпоследняя ячейка - грузим следующую страницу
        NSInteger totalPages = ceil((double)totalListItems / listPager.onpage);
        if (listPager.page == totalPages || totalListItems == listItems.count) {
            // загрузили все, что было
        }
        else {
            listPager.page += 1;
            [self performLoading];
        }
    }
    
    // кеширование высот ячеек
    NSString *key = [NSString stringWithFormat:@"%ld_%ld", indexPath.section, indexPath.row];
    NSNumber *height = [cellHeights objectForKey:key];
    if (height == nil) {
        CGFloat cellHeight = cell.contentView.frame.size.height;
        [cellHeights setValue:[NSNumber numberWithDouble:cellHeight] forKey:key];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (totalListItems == 0 && [listItems count] == 0 && self.listTable.backgroundView == nil) {
        //create a lable size to fit the Table View
        UILabel *messageLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,
                                                                        self.listTable.bounds.size.width,
                                                                        self.listTable.bounds.size.height)];
        //set the message
        messageLbl.text = loaded ?  @"Список пуст" : @"Загружается...";
        //center the text
        messageLbl.textAlignment = NSTextAlignmentCenter;
        //auto size the text
        [messageLbl sizeToFit];
        
        //set back to label view
        self.listTable.backgroundView = messageLbl;
        //no separator
        self.listTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //[ApiDataManager addfriend:2 success:nil error:nil];
        
        return 0;
    }
    else if (totalListItems > 0) {
        self.listTable.backgroundView = nil;
    }
    else if (self.listTable.backgroundView != nil) {
        ((UILabel *)self.listTable.backgroundView).text = loaded ?  @"Список пуст" : @"Загружается...";
    }
    
    return [listSections count];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return listSections;
//}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString*)title atIndex:(NSInteger)index {
    return index;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [listSections objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 24;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] init];
    }
    UserListSectionHeaderCell *sectionCell = [self.listTable dequeueReusableCellWithIdentifier:NSStringFromClass([UserListSectionHeaderCell class])];
    if (sectionCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([UserListSectionHeaderCell class]) owner:self options:nil];
        sectionCell = [nib objectAtIndex:0];
    }
    return sectionCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"itemClick: position = %ld", (long)indexPath.row);
    
    if (selectItem) {
        id listItem = [[self listItemsBySection:indexPath.section] objectAtIndex:indexPath.row];
        selectItem(listItem);
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UILabel *)labelForSection:(NSInteger)section {
    UIFont *font = [UIFont fontWithName:@"Roboto-Light" size:24]; //custom font
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, 40, 32)];
    label.text = [listSections objectAtIndex:section];
    label.font = font;
    label.numberOfLines = 1;
    label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    label.adjustsFontSizeToFitWidth = NO;
    label.clipsToBounds = YES;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:0.247 green:0.317 blue:0.709 alpha:1];
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

- (void)deleteCell:(UITableViewCell *)cell {
    NSIndexPath *path = [self.listTable indexPathForCell:cell];
    if (!path) {
        return;
    }
    // todo: не поддерживаются секции!
    [listItems removeObjectAtIndex:path.row];
    [self generateSections];

//    NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:path, nil];
//    [self.listTable beginUpdates];
//    [self.listTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
//    [self.listTable endUpdates];
    
    [self.listTable reloadData];
}

@end
