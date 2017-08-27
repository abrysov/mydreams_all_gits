//
//  PMButton.h
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBorderedButton : UIButton
@property (assign, nonatomic) IBInspectable CGFloat kern;
@property (strong, nonatomic) IBInspectable UIColor *normalBorderColor;
@property (strong, nonatomic) IBInspectable UIColor *normalFillColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedBorderColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedFillColor;
@end