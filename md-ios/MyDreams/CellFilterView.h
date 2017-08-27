//
//  CellFilterView.h
//  MyDreams
//
//  Created by user on 04.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CellFilterViewState) {
    CellFilterViewStateInactive,
    CellFilterViewStateActive,
};

@interface CellFilterView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (assign, nonatomic) CellFilterViewState inputState;
@end
