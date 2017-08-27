//
//  CellSettingsView.h
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMCellSettingsViewInputState) {
    PMCellSettingsViewInputStateNone,
    PMCellSettingsViewInputStateValid,
    PMCellSettingsViewInputStateInvalid,
};

@interface CellSettingsView : UIView
@property (assign, nonatomic) PMCellSettingsViewInputState inputState;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;
@property (strong, nonatomic) IBInspectable UIColor *labelColor;
@property (strong, nonatomic) IBInspectable UIImage *icon;
@property (assign, nonatomic) IBInspectable BOOL hideSeparator;
@property (assign, nonatomic) IBInspectable BOOL disableTextField;
@end
