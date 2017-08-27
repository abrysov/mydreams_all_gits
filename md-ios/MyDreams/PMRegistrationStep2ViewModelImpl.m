//
//  PMRegistrationStep2ViewModelImpl.m
//  MyDreams
//
//  Created by user on 01.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationStep2ViewModelImpl.h"
#import "PMUserForm.h"

@interface PMRegistrationStep2ViewModelImpl ()
@property (assign, nonatomic) PMDreamerGender sex;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *dayBirthday;
@property (strong, nonatomic) NSString *monthBirthday;
@property (strong, nonatomic) NSString *yearBirthday;

@property (nonatomic, assign) BOOL isValidFirstName;
@property (nonatomic, assign) BOOL isValidSecondName;
@property (nonatomic, assign) BOOL isValidBirthDay;
@property (nonatomic, assign) BOOL isValidGender;
@end

@implementation PMRegistrationStep2ViewModelImpl

- (instancetype)initWithUserForm:(PMUserForm *)userForm
{
    self = [super init];
    if (self) {
        @weakify(self);
        
        RAC(self, sex) = RACObserve(userForm, sex);
        
        [RACObserve(userForm, birthday)
            subscribeNext:^(NSDate *date) {
                @strongify(self);
                if (date) {
                    [self leadDateToString:userForm.birthday];
                }
                self.birthday = date;
            }];
        
        RAC(self, isValidFirstName) = RACObserve(userForm, isValidFirstName);
        RAC(self, isValidSecondName) = RACObserve(userForm, isValidSecondName);
        RAC(self, isValidBirthDay) = RACObserve(userForm, isValidBirthDay);
        RAC(self, isValidGender) = RACObserve(userForm, isValidGender);
    }
    return self;
}

- (void)leadDateToString:(NSDate *)birthday
{
    NSCalendar *const calendar = NSCalendar.currentCalendar;
    NSCalendarUnit const preservedComponents = (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay);
    NSDateComponents *const components = [calendar components:preservedComponents fromDate:birthday];
    self.dayBirthday = [NSString stringWithFormat:@"%ld", (long)components.day];
    self.monthBirthday = [self.monthFormatter stringFromDate:birthday];
    self.yearBirthday = [NSString stringWithFormat:@"%ld", (long)components.year];
}

- (NSDateFormatter *)monthFormatter
{
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MMM";
    });
    return formatter;
}


@end
