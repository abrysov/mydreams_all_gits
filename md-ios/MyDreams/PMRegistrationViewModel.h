//
//  PMRegistrationViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMRegistrationViewModel <NSObject>
@property (nonatomic, assign, readonly) BOOL isValidPassword;
@property (nonatomic, assign, readonly) BOOL isValidEmail;
@property (nonatomic, assign, readonly) BOOL isValidConfirmPassword;
@end
