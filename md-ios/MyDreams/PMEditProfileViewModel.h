//
//  PMEditProfileViewModel.h
//  MyDreams
//
//  Created by user on 02.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerGender.h"

@protocol PMEditProfileViewModel <NSObject>
@property (strong, nonatomic, readonly) UIImage *avatar;
@property (strong, nonatomic, readonly) NSDate *birthday;
@property (strong, nonatomic, readonly) NSString *dayBirthday;
@property (strong, nonatomic, readonly) NSString *monthBirthday;
@property (strong, nonatomic, readonly) NSString *yearBirthday;
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSString *locality;
@property (assign, nonatomic, readonly) PMDreamerGender gender;
@property (assign, nonatomic, readonly) BOOL isValidFirstName;
@property (assign, nonatomic, readonly) BOOL isValidSecondName;
@end
