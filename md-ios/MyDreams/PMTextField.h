//
//  PMTextField.h
//  MyDreams
//
//  Created by Иван Ушаков on 02.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMTextFieldInputState) {
    PMTextFieldInputStateNone,
    PMTextFieldInputStateValid,
    PMTextFieldInputStateInvalid,
};

@interface PMTextField : UITextField
@property (assign, nonatomic) PMTextFieldInputState inputState;
@property (strong, nonatomic) IBInspectable UIImage *icon;
@end
