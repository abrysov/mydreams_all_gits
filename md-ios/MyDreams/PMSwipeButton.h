//
//  PMSwipeButton.h
//  MyDreams
//
//  Created by Alexey Yakunin on 03/08/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UITableViewCell;

@interface PMSwipeButton : UIButton
typedef void(^PMSwipeButtonCallback)(UITableViewCell *cell);
@property (nonatomic, strong) PMSwipeButtonCallback callback;
+(instancetype) buttonWithTitle:(NSString *) title backgroundColor:(UIColor *) color callback:(PMSwipeButtonCallback) callback;
@end
