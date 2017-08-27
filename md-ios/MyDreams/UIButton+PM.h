//
//  UIButton+PM.h
//  MyDreams
//
//  Created by Иван Ушаков on 15.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PM)
@property (nonatomic) IBInspectable UIColor *backgroundColorForNormalState;
@property (nonatomic) IBInspectable UIColor *backgroundColorForDisabledState;
@property (nonatomic) IBInspectable UIColor *backgroundColorForHighlightedState;
@property (nonatomic) IBInspectable UIColor *backgroundColorForSelectedState;
@end
