//
//  TopDreamCell.h
//  MyDreams
//
//  Created by Игорь on 16.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DreamCell.h"
#import "BaseViewController.h"
#import "ProposedDreamsViewController.h"

@interface ProposedDreamCell : DreamCell

@property (weak, nonatomic) id<DeleteCellDelegate> deleteCellDelegate;

- (IBAction)acceptTouch:(id)sender;
- (IBAction)rejectTouch:(id)sender;

@end
