//
//  FlybookViewController.h
//  MyDreams
//
//  Created by Игорь on 05.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MWPhotoBrowser.h"

@interface FlybookViewController : BaseViewController<MWPhotoBrowserDelegate>

//@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *quoteLabel;
//@property (weak, nonatomic) IBOutlet UILabel *friendsCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *subscribersCountLabel;
//@property (weak, nonatomic) IBOutlet UILabel *launchesCountLabel;

@property (assign, atomic) NSInteger userId;

@property (weak, nonatomic) IBOutlet UITableView *flybookTable;

@end
