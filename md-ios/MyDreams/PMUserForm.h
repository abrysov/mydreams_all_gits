//
//  PMUserData.h
//  MyDreams
//
//  Created by user on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMLocalityForm.h"
#import "PMLocation.h"
#import "PMLocality.h"
#import "PMImageForm.h"
#import "PMDreamerGender.h"

@class  PMEmailValidator;

@interface PMUserForm: PMBaseModel
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *secondName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *confirmPassword;
@property (strong, nonatomic) NSDate *birthday;
@property (assign, nonatomic) PMDreamerGender sex;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) PMLocalityForm *customLocality;
@property (strong, nonatomic) PMLocation *country;
@property (strong, nonatomic) PMLocality *locality;
@property (strong, nonatomic) PMImageForm *avatarForm;

@property (nonatomic, assign) BOOL isValidPassword;
@property (nonatomic, assign) BOOL isValidEmail;
@property (nonatomic, assign) BOOL isValidFirstName;
@property (nonatomic, assign) BOOL isValidSecondName;
@property (nonatomic, assign) BOOL isValidBirthDay;
@property (nonatomic, assign) BOOL isValidGender;
@property (nonatomic, assign) BOOL isValidPhoneNumber;
@property (nonatomic, assign) BOOL isValidConfirmPassword;

- (void)validatePassword;
- (void)validateEmail;
- (void)validateFirstName;
- (void)validateGender;
- (void)validateConfirmPassword;

- (instancetype)initWithEmailValidator:(PMEmailValidator *)emailValidator;
@end
