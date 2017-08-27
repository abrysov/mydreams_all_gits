//
//  PMGradientView.h
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMGradientView : UIView
@property (strong, nonatomic) IBInspectable UIColor *startColor;
@property (strong, nonatomic) IBInspectable UIColor *endColor;
@property (assign, nonatomic) IBInspectable CGPoint startPoint;
@property (assign, nonatomic) IBInspectable CGPoint endPoint;
@end
