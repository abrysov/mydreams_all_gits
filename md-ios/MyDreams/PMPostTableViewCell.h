//
//  PMPostTableViewCell.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMPostViewModel.h"
#import "PMEstimatedRowHeight.h"

@interface PMPostTableViewCell : UITableViewCell <PMEstimatedRowHeight>
@property (strong, nonatomic) id<PMPostViewModel> viewModel;
@property (strong, nonatomic) RACCommand *toFullPostCommand;
@end
