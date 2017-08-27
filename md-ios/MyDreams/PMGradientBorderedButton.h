//
//  PMGradientBorderedButton.h
//  MyDreams
//
//  Created by Alexey Yakunin on 13/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButton.h"

@interface PMGradientBorderedButton : UIButton

@property (assign, nonatomic) IBInspectable CGFloat kern;
@property (strong, nonatomic) IBInspectable UIColor *normalBorderColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedBorderColor;
@property (strong, nonatomic) IBInspectable UIColor *normalStartColor;
@property (strong, nonatomic) IBInspectable UIColor *normalEndColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedStartColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedEndColor;

@end
