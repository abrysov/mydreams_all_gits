//
//  PMSexView.h
//  MyDreams
//
//  Created by user on 21.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMSexViewInputState) {
    PMSexViewInputStateNone,
    PMSexViewInputStateSelected,
    PMSexViewInputStateInvalid,
};

@interface PMSexView : UIView
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
@property (assign, nonatomic) PMSexViewInputState inputState;
@end
