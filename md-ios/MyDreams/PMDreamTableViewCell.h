//
//  Dreambox.h
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMEstimatedRowHeight.h"

@protocol PMDreamViewModel;

@interface PMDreamTableViewCell : UITableViewCell <PMEstimatedRowHeight>
@property (strong, nonatomic) UIColor *staticColor;
@property (strong, nonatomic) id<PMDreamViewModel> viewModel;
@property (strong, nonatomic) RACCommand *toFullDreamCommand;
@end
