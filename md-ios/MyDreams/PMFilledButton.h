//
//  PMFilledButton.h
//  MyDreams
//
//  Created by Иван Ушаков on 03.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMFilledButton : UIButton
@property (strong, nonatomic) IBInspectable UIColor *normalColor;
@property (strong, nonatomic) IBInspectable UIColor *selectedColor;
@end
