//
//  PMDreamerTableViewCell.h
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMDreamerViewModel.h"
#import "PMEstimatedRowHeight.h"

@interface PMDreamerTableViewCell : UITableViewCell <PMEstimatedRowHeight>
@property (strong, nonatomic) id<PMDreamerViewModel> viewModel;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@end
