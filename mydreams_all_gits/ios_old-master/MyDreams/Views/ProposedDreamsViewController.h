//
//  ProposedDreamsViewController.h
//  MyDreams
//
//  Created by Игорь on 28.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"

@protocol DeleteCellDelegate

- (void)deleteCell:(UITableViewCell *)cell;

@end


@interface ProposedDreamsViewController : BaseViewController<DeleteCellDelegate>

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> tabsDelegate;

@end
