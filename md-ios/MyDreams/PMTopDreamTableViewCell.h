//
//  PMTopDreamTableViewCell.h
//  MyDreams
//
//  Created by user on 22.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMEstimatedRowHeight.h"

@protocol PMDreamViewModel;

@interface PMTopDreamTableViewCell : UITableViewCell <PMEstimatedRowHeight>
@property (strong, nonatomic) id<PMDreamViewModel> viewModel;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;
@end
