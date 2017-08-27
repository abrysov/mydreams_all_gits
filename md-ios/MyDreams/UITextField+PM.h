//
//  UITextField+PM.h
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PM)
- (void)establishChannelToTextWithTerminal:(RACChannelTerminal *)otherTerminal;
@end
