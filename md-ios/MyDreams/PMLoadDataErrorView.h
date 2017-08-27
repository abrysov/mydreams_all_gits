//
//  PMBlankStateView.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMLoadDataErrorView : UIView
@property (assign, nonatomic) BOOL isTransparent;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) RACCommand *rac_command;
@property (nonatomic, strong) NSString *errorString;
@end
