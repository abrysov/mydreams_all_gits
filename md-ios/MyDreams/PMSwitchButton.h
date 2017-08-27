//
//  PMSwitchButton.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PMSwitchButtonViewState) {
    PMSwitchButtonViewStateInactive,
    PMSwitchButtonViewStateActive,
};

@protocol PMSwitchButton <NSObject>
@property (assign, nonatomic) PMSwitchButtonViewState inputState;
@property (nonatomic, weak, readonly) UIButton *button;
- (instancetype)initWitBottomLineColor:(UIColor *)color;
@end