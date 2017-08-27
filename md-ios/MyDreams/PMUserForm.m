//
//  PMUserDataModel.m
//  MyDreams
//
//  Created by user on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserForm.h"
#import "PMImageForm.h"
#import "PMEmailValidator.h"
#import "PMDreamer.h"
#import "PMFile.h"

@interface PMUserForm()
@property (nonatomic, weak) PMEmailValidator *emailValidator;
@end

@implementation PMUserForm

- (instancetype)initWithEmailValidator:(PMEmailValidator *)emailValidator
{
    self = [super init];
    if (self) {
        [self setup];
        self.emailValidator = emailValidator;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

#pragma mark - json

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    NSDictionary *mapping = @{
                              PMSelectorString(email): @"email",
                              PMSelectorString(firstName): @"first_name",
                              PMSelectorString(secondName): @"last_name",
                              PMSelectorString(password): @"password",
                              PMSelectorString(sex): @"gender",
                              PMSelectorString(birthday): @"birthday",
                              PMSelectorString(country): @"country_id",
                              PMSelectorString(locality): @"city_id",
                              PMSelectorString(phoneNumber): @"phone"
                              };
    return mapping;
}

+ (NSValueTransformer *)sexJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"male": @(PMDreamerGenderMale),
                                                                           @"female": @(PMDreamerGenderFemale)
                                                                           } defaultValue:PMDreamerGenderUnknow reverseDefaultValue:[NSNull null]];
}

+ (NSValueTransformer *)birthdayJSONTransformer
{
    @weakify(self);
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        @strongify(self);
        NSString *date = [[self birthdayDateFormatter] stringFromDate:value];
        
        if (date) {
            *success = YES;
        }
        
        return date;
    }];
}

+ (NSValueTransformer *)countryJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        PMLocation *country = (PMLocation *)value;
        *success = YES;
        return country.idx;
    }];
}

+ (NSValueTransformer *)localityJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        PMLocality *locality = (PMLocality *)value;
        *success = YES;
        return locality.idx;
    }];
}

+ (NSDateFormatter *)birthdayDateFormatter
{
    static dispatch_once_t onceToken;
    static NSDateFormatter *formatter;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"dd-MM-YYYY";
    });
    
    return formatter;
}


#pragma mark - validation

- (void)validatePassword
{
    NSString *trimmedString = [self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.isValidPassword = (trimmedString.length > 5) && (trimmedString.length < 255);
}

- (void)validateConfirmPassword
{
    self.isValidConfirmPassword = [self.password isEqualToString:self.confirmPassword];
}

- (void)validateEmail
{
    self.isValidEmail = [self.emailValidator isEmailValid:self.email];
}

- (void)validateFirstName
{
    self.isValidFirstName = (self.firstName.length != 0);
}

- (void)validateGender
{
    self.isValidGender = (self.sex != PMDreamerGenderUnknow);
}

#pragma mark - private

- (void)setup
{
    @weakify(self);
    
    self.isValidPassword = YES;
    self.isValidEmail = YES;
    self.isValidFirstName = YES;
    self.isValidSecondName = YES;
    self.isValidBirthDay = YES;
    self.isValidGender = YES;
    self.isValidPhoneNumber = YES;
    self.isValidConfirmPassword = YES;
    
    self.sex = PMDreamerGenderFemale;
    
    [[RACObserve(self, password)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self validatePassword];
         if (self.confirmPassword) {
             [self validateConfirmPassword];
         }
     }];
    
    [[RACObserve(self, confirmPassword)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self validateConfirmPassword];
     }];
    
    [[RACObserve(self, email)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self validateEmail];
     }];
    
    [[RACObserve(self, firstName)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self validateFirstName];
     }];
    
    [[RACObserve(self, secondName)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         self.isValidSecondName = YES;
     }];
    
    [[RACObserve(self, birthday)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         self.isValidBirthDay = YES;
     }];
    
    [[RACObserve(self, sex)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         [self validateGender];
     }];
    
    [[RACObserve(self, phoneNumber)
      distinctUntilChanged]
     subscribeNext:^(id x) {
         @strongify(self);
         self.isValidPhoneNumber = YES;
     }];
}

@end
