//
//  PMStatusTextField.h
//  MyDreams
//
//  Created by user on 19.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PMStatusTextFieldInputState) {
    PMStatusTextFieldInputStateClear,
    PMStatusTextFieldInputStateFull,
};

@interface PMStatusTextField : UITextField
@property (assign, nonatomic) PMStatusTextFieldInputState inputState;
@end
