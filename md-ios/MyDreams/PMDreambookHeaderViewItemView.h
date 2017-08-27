//
//  PMStateDreambookView.h
//  MyDreams
//
//  Created by user on 18.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookHeaderViewItemType.h"

@interface PMDreambookHeaderViewItemView : UIView
@property (strong, nonatomic) NSString *title;
@property (assign, nonatomic) NSUInteger count;
@property (assign, nonatomic) PMDreambookHeaderViewItemType type;
@property (strong, nonatomic) IBInspectable UIImage *icon;
@property (assign, nonatomic) NSInteger badgeValue;
@property (strong, nonatomic) RACCommand *buttonCommand;
@end
