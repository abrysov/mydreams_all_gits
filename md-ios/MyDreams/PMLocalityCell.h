//
//  PMLocalityCell.h
//  MyDreams
//
//  Created by user on 24.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMLocalityViewModel.h"

@interface PMLocalityCell : UITableViewCell
@property (nonatomic, strong) id<PMLocalityViewModel> viewModel;
@end
