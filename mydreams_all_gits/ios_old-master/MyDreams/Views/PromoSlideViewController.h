//
//  PromoSlideViewController.h
//  MyDreams
//
//  Created by Игорь on 22.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromoSlideViewController : UIViewController

@property (assign, nonatomic) NSInteger index;

+ (UIColor *)getColor:(NSInteger)index;

@end
