//
//  PMCellFillView.h
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMCellFillViewInputState) {
    PMCellFillViewInputStateNone,
    PMCellFillViewInputStateValid,
    PMCellFillViewInputStateInvalid,
};

@interface PMCellFillView : UIView
@property (assign, nonatomic) PMCellFillViewInputState inputState;
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@end
