//
//  DreambookProfileViewController.h
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "MWPhotoBrowser.h"
#import "Flybook.h"

@interface DreambookProfileViewController : BaseViewController<MWPhotoBrowserDelegate, UpdatableViewControllerDelegate>

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> tabsDelegate;

@property (retain, nonatomic) Flybook *profile;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
