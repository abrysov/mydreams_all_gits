//
//  FlybookViewController.m
//  MyDreams
//
//  Created by Игорь on 05.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <SVPullToRefresh/UIScrollView+SVInfiniteScrolling.h>
#import <SVPullToRefresh/UIScrollView+SVPullToRefresh.h>
#import "FlybookViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"
#import "FlybookProfileCell.h"
#import "ProposedCell.h"
#import "Constants.h"
#import "DreamCell.h"
#import "DreamRootViewController.h"
#import "EditProfileViewController.h"
#import "ProfilePhotosViewController.h"
#import "ProposedDreamsViewController.h"
#import "MWPhotoBrowser.h"

@interface FlybookViewController ()

@end

@implementation FlybookViewController {
    BOOL loaded;
    BOOL showProposedCell;
    BOOL isSelf;
    BOOL isVip;
    Flybook *flybook;
    Pager *listPager;
    NSInteger totalListItems;
    NSMutableArray *listItems;
    NSMutableDictionary *cellHeights;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isSelf = self.userId == 0 || self.userId == [Helper profileUserId];
    
    self.flybookTable.tableFooterView = [[UIView alloc] init];
    //self.flybookTable.rowHeight = UITableViewAutomaticDimension;
    //self.flybookTable.estimatedRowHeight = 500;
    self.flybookTable.separatorColor = [UIColor clearColor];
    
    self.title = [Helper localizedString:@"_FLYBOOK_TITLE"];
    
    [self.flybookTable registerNib:[UINib nibWithNibName:@"FlybookProfileCell" bundle:nil] forCellReuseIdentifier:@"FlybookProfileCell"];
    [self.flybookTable registerNib:[UINib nibWithNibName:@"FlybookProfileGuestCell" bundle:nil] forCellReuseIdentifier:@"FlybookProfileGuestCell"];
    [self.flybookTable registerNib:[UINib nibWithNibName:@"DreamCell" bundle:nil] forCellReuseIdentifier:@"DreamCell"];
    [self.flybookTable registerNib:[UINib nibWithNibName:@"ProposedCell" bundle:nil] forCellReuseIdentifier:@"ProposedCell"];
 
    cellHeights = [[NSMutableDictionary alloc] init];
    
    [self setupInfiniteScroll];
    
    [self performLoading];
}

- (AppearenceStyle)appearenceStyle {
    isVip = isSelf ? [Helper profileIsVip] : (flybook ? [flybook isVip] : false);
    return isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE;
}

- (NSInteger)activeMenuItem {
    return isSelf ? 2 : -1;
}

-(BOOL)isSectionRoot {
    return YES;
}

- (void)setupInfiniteScroll {
    [self.flybookTable addPullToRefreshWithActionHandler:^{
        [self reloadList];
    }];
    
    UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [view setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [view setColor:[UIColor grayColor]];
    [view startAnimating];
    [self.flybookTable.pullToRefreshView setCustomView:view forState:SVPullToRefreshStateAll];
}

- (void)setupContextMenu {
    NSLog(@"profile %ld", [Helper profileUserId]);
    [super setupContextMenu];
}

- (NSArray *)setupAlertActions {
    if (isSelf) {
        return [self setupSelfAlertActions];
    }
    else {
        return [self setupUserAlertActions];
    }
}

- (NSArray *)setupSelfAlertActions {
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *proposeAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_PROFILE_EDIT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goEdit];
    }];
    [alertActions addObject:proposeAction];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_PROFILE_PHOTOS"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goPhotos];
    }];
    [alertActions addObject:photosAction];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"_LOGOUT"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self logout];
    }];
    [alertActions addObject:logoutAction];
    
    return alertActions;
}

- (NSArray *)setupUserAlertActions {
    if (flybook == nil) {
        return nil;
    }
    
    NSMutableArray *alertActions = [[NSMutableArray alloc] init];
    
    UIAlertAction *photosAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Фотографии"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self goPhotos];
    }];
    [alertActions addObject:photosAction];
    
    if (flybook.friend) {
        UIAlertAction *unfriendAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Удалить из друзей"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self unfriend:flybook.id];
        }];
        [alertActions addObject:unfriendAction];
    }
    else if (!flybook.friendshipRequestSended) {
        UIAlertAction *requestAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Добавить в друзья"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self requestFriendship:flybook.id];
        }];
        [alertActions addObject:requestAction];
    }
    else {
        UIAlertAction *denyAction = [UIAlertAction actionWithTitle:[Helper localizedString:@"Отклонить заявку"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self denyrequest:flybook.id];
        }];
        [alertActions addObject:denyAction];
    }
    
    return alertActions;
}

- (void)performLoading {
    [ApiDataManager flybook:self.userId success:^(Flybook *flybook_) {
        flybook = flybook_;
        isVip = flybook_.isVip;
        
        
        //!
        flybook.proposed = 8;
        //
        
        
        loaded = YES;
        showProposedCell = flybook.proposed > 0;
        
        listItems = (id)[[NSMutableArray alloc] init];
        listPager = [[Pager alloc] initWith:1 onpage:2];
        [self performLoadingList];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.flybookTable reloadData];
        });
        
        if (isSelf) {
            [Helper updateProfile:flybook_];
        }
        
        [self setupContextMenu];
        [self setupAppearence];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)performLoadingList {
    NSLog(@"Try retreive data on page %ld", (long)listPager.page);
    [ApiDataManager flybooklist:self.userId isdone:0 pager:listPager success:^(NSInteger total, NSArray<Dream> *dreams) {
        totalListItems = total;
        NSLog(@"%ld items retreived", (unsigned long)dreams.count);
        if (dreams.count > 0) {
            [listItems addObjectsFromArray:dreams];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.flybookTable reloadData];
            });
        }
        else if (listPager.page > 1) {
            // пришел пустой список - декремент страницы, там ничего нет
            listPager.page -= 1;
        }
        [self.flybookTable.infiniteScrollingView stopAnimating];
        [self.flybookTable.pullToRefreshView stopAnimating];
    } error:^(NSString *error) {
        [self showAlert:error];
        [self.flybookTable.infiniteScrollingView stopAnimating];
        [self.flybookTable.pullToRefreshView stopAnimating];
    }];
}

- (void)reloadList {
    totalListItems = -1;
    listItems = [[NSMutableArray alloc] init];
    listPager = [[Pager alloc] initWith:1 onpage:5];
    cellHeights = [[NSMutableDictionary alloc] init];
    [self performLoadingList];
    [self.flybookTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self.flybookTable reloadData];
//}

- (NSInteger)getListOffset {
    return showProposedCell ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        NSString *cellId = @"FlybookProfileCell";//isSelf ? @"FlybookProfileCell" : @"FlybookProfileGuestCell";
        FlybookProfileCell *profileCell = [self.flybookTable dequeueReusableCellWithIdentifier:cellId];
        if (profileCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellId owner:self options:nil];
            profileCell = [nib objectAtIndex:0];
        }
        
        [profileCell initUIWith:flybook];
        
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startGallery:)];
        [profileCell.avatarImageView addGestureRecognizer:tapAvatar];
        
        cell = profileCell;
    }
    else if (indexPath.row == 1 && showProposedCell) {
        ProposedCell *proposedCell = [self.flybookTable dequeueReusableCellWithIdentifier:NSStringFromClass([ProposedCell class])];
        if (proposedCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ProposedCell class]) owner:self options:nil];
            proposedCell = [nib objectAtIndex:0];
        }
        
        [proposedCell initUIWith:flybook.proposed appearence:isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
        [proposedCell initHiding:self action:@selector(hideProposed)];
        [proposedCell initGoProposed:self action:@selector(goProposed)];
        cell = proposedCell;
    }
    else {
        DreamCell *dreamCell = [self.flybookTable dequeueReusableCellWithIdentifier:NSStringFromClass([DreamCell class])];
        if (dreamCell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DreamCell class]) owner:self options:nil];
            dreamCell = [nib objectAtIndex:0];
        }
        
        Dream *dream = [listItems objectAtIndex:indexPath.row - [self getListOffset]];
        [dreamCell initUIWith:dream andAppearence:isVip ? AppearenceStylePURPLE : AppearenceStyleBLUE];
        cell = dreamCell;
        NSLog(@"init cell %ld", (long)indexPath.row);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [listItems count] + [self getListOffset] - 1) {
        // показывается предпоследняя ячейка - грузим следующую страницу
        NSInteger totalPages = ceil((double)totalListItems / listPager.onpage);
        if (listPager.page == totalPages || totalListItems == listItems.count) {
            // загрузили все, что было
        }
        else {
            listPager.page += 1;
            [self performLoadingList];
        }
    }
    
    // кеширование высот ячеек
    NSString *key = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    NSNumber *height = [cellHeights objectForKey:key];
    if (height == nil) {
        CGFloat cellHeight = cell.contentView.frame.size.height;
        [cellHeights setValue:[NSNumber numberWithDouble:cellHeight] forKey:key];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightAtIndex:indexPath.row];
    //return showProposedCell && indexPath.row == 1 ? 96 : UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightAtIndex:indexPath.row];
    //return showProposedCell && indexPath.row == 1 ? 96 : 1200;
}

- (CGFloat)cellHeightAtIndex:(NSInteger)index {
    NSString *key = [NSString stringWithFormat:@"%ld", (long)index];
    NSNumber *height = [cellHeights objectForKey:key];
    return height == nil ? UITableViewAutomaticDimension : [height doubleValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (loaded) {
        return listItems.count + [self getListOffset];
    }
    else {
        // пока профиль не загружен - не показываем ячейки
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)path {
    if (path.row == 0) {
        return nil;
    }
    return path;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"itemClick: position = %ld", (long)indexPath.row);
    
    if ([self getListOffset] == 2 && indexPath.row == 1) {
        [self goProposed];
        return;
    }
    
    NSInteger index = indexPath.row - [self getListOffset];
    Dream *selectedDream = (Dream *)[listItems objectAtIndex:index];
    NSLog(@"selectedDream id %ld", (long)selectedDream.id);
    NSLog(@"selectedDream name %@", selectedDream.name);
    
    NSIndexPath *selectedPath = [self.flybookTable indexPathForSelectedRow];
    [self.flybookTable deselectRowAtIndexPath:selectedPath animated:NO];
    [self goDream:selectedDream.id];
}

- (void)hideProposed {
    if (showProposedCell) {
        showProposedCell = false;
        cellHeights = [[NSMutableDictionary alloc] init];
        
        NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:1 inSection:0], nil];
        [self.flybookTable beginUpdates];
        [self.flybookTable deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.flybookTable endUpdates];
    }
}

- (void)goDream:(NSInteger)dreamId {
    DreamRootViewController *dreamViewController = [[DreamRootViewController alloc] initWithNibName:@"DreamRootViewController" bundle:nil];
    dreamViewController.dreamId = dreamId;
    [self.navigationController pushViewController:dreamViewController animated:YES];
}

- (void)goEdit {
    EditProfileViewController *editViewController = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil];
    [self.navigationController pushViewController:editViewController animated:YES];
}

- (void)goPhotos {
    ProfilePhotosViewController *photosViewController = [[ProfilePhotosViewController alloc] initWithNibName:@"ProfilePhotosViewController" bundle:nil];
    photosViewController.userId = self.userId;
    [self.navigationController pushViewController:photosViewController animated:YES];
}

- (void)goProposed {
    ProposedDreamsViewController *proposedDreamsViewController = [[ProposedDreamsViewController alloc] initWithNibName:@"ProposedDreamsViewController" bundle:nil];
    [self.navigationController pushViewController:proposedDreamsViewController animated:YES];
}

- (void)requestFriendship:(NSInteger)userId {
    [ApiDataManager requestfriendship:userId success:^{
        [self showAlert:@"Заявка отправлена"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)unfriend:(NSInteger)userId {
    [ApiDataManager unfriend:userId success:^{
        [self showAlert:@"Друг удален"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)denyrequest:(NSInteger)userId {
    [ApiDataManager denyrequest:userId success:^{
        [self showAlert:@"Заявка отклонена"];
        [self performLoading];
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (void)startGallery:(UIImageView *)imageView {
    if ([self numberOfPhotosInPhotoBrowser:nil] == 0) {
        return;
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    
    [browser setCurrentPhotoIndex:0];
    
    [self.navigationController pushViewController:browser animated:YES];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [flybook.photos count] + ((flybook.avatarUrl && [flybook.avatarUrl length] > 0) ? 1 : 0);
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index >= [self numberOfPhotosInPhotoBrowser:nil]) {
        return nil;
    }
    
    NSInteger photosOffset = flybook.avatarUrl && [flybook.avatarUrl length] > 0 ? 1 : 0;
    
    NSString *imageUrl;
    if (index == 0 && photosOffset > 0) {
        imageUrl = flybook.avatarUrl;
    }
    else {
        FlybookPhoto *photo = [flybook.photos objectAtIndex:index - photosOffset];
        imageUrl = photo.url;
    }
    NSString *fullUrl = ([[imageUrl substringToIndex:4] isEqualToString:@"http"])
        ? imageUrl
        : [NSString stringWithFormat:@"%@%@", SERVER_URL, imageUrl];
    return [[MWPhoto alloc] initWithURL:[NSURL URLWithString:fullUrl]];
}

@end
