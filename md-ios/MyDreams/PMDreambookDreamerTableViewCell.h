//
//  PMDreambookDreamerTableViewCell.h
//  MyDreams
//
//  Created by user on 24.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMEstimatedRowHeight.h"

@protocol PMDreambookDreamerViewModel;

@interface PMDreambookDreamerTableViewCell : UITableViewCell <PMEstimatedRowHeight>
@property (strong, nonatomic) id<PMDreambookDreamerViewModel> viewModel;
@property (strong, nonatomic) RACCommand *toDreambookCommand;
@end
