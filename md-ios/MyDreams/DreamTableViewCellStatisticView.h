//
//  DreamboxState.h
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DreamTableViewCellStatisticView : UIView
@property (strong, nonatomic) IBInspectable UIImage *icon;
@property (assign, nonatomic) NSUInteger count;

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (strong, nonatomic) IBInspectable UIColor* textColor;
@property (strong, nonatomic) IBInspectable UIColor* containerBackgroundColor;
@end
