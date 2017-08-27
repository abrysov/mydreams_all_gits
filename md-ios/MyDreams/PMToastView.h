//
//  PMToastVIew.h
//  MyDreams
//
//  Created by user on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMToastView : UIView
- (instancetype)initWithTitle:(NSString *)title buttonCommand:(RACCommand *)command;
- (void)hideToast;
@end
