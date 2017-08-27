//
//  PMRegistrationStep2ViewModel.h
//  MyDreams
//
//  Created by user on 01.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerGender.h"

@protocol PMRegistrationStep2ViewModel <NSObject>
@property (assign, nonatomic, readonly) PMDreamerGender sex;
@property (strong, nonatomic, readonly) NSDate *birthday;
@property (strong, nonatomic, readonly) NSString *dayBirthday;
@property (strong, nonatomic, readonly) NSString *monthBirthday;
@property (strong, nonatomic, readonly) NSString *yearBirthday;

@property (nonatomic, assign, readonly) BOOL isValidFirstName;
@property (nonatomic, assign, readonly) BOOL isValidSecondName;
@property (nonatomic, assign, readonly) BOOL isValidBirthDay;
@property (nonatomic, assign, readonly) BOOL isValidGender;
@end
