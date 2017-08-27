//
//  PMSegmentControl.h
//  MyDreams
//
//  Created by user on 25.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSwitchButtonView.h"

@class PMSegmentControl;

@protocol PMSegmentControlDelegate <NSObject>
- (void)SegmentControl:(PMSegmentControl *)segmentControl SwitchedOn:(NSInteger)index;
@end

@interface PMSegmentControl : UIView

@property (nonatomic, weak) id<PMSegmentControlDelegate> delegate;
@property (nonatomic, assign) CGFloat spacing;
- (instancetype)initWithItems:(NSArray *)items bottomLineColor:(UIColor *)color class:(id)xibClass;

- (void)changeSegmentOn:(NSInteger)index;
@end
