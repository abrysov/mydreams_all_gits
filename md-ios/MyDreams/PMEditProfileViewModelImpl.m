//
//  PMEditProfileViewModelImpl.m
//  MyDreams
//
//  Created by user on 02.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditProfileViewModelImpl.h"
#import "PMDreamerGender.h"

@interface PMEditProfileViewModelImpl ()
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *dayBirthday;
@property (strong, nonatomic) NSString *monthBirthday;
@property (strong, nonatomic) NSString *yearBirthday;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *locality;
@property (assign, nonatomic) PMDreamerGender gender;
@property (assign, nonatomic) BOOL isValidFirstName;
@property (assign, nonatomic) BOOL isValidSecondName;
@end

@implementation PMEditProfileViewModelImpl

- (instancetype)initWithDreamerForm:(PMDreamerForm *)dreamerForm
{
    self = [super init];
    if (self) {
        
        @weakify(self);
        [[RACObserve(dreamerForm, birthday) ignore:nil] subscribeNext:^(NSDate *date) {
             @strongify(self);
             [self leadDateToString:date];
             self.birthday = date;
         }];
        
        [[RACObserve(dreamerForm, country.name) ignore:nil] subscribeNext:^(NSString *value) {
             @strongify(self);
             self.country = value;
         }];
        
        [RACObserve(dreamerForm, locality.name) subscribeNext:^(NSString *value) {
             @strongify(self);
             self.locality = value;
         }];
        
        [[RACObserve(dreamerForm, avatarForm.cropedImage) ignore:nil] subscribeNext:^(UIImage *image) {
            @strongify(self);
            self.avatar = image;
        }];
        
        [[RACObserve(dreamerForm, avatar) ignore:nil] subscribeNext:^(UIImage *image) {
            @strongify(self);
            self.avatar = image;
        }];
        
        [RACObserve(dreamerForm, sex) subscribeNext:^(NSNumber *value) {
            @strongify(self);
            self.gender = [value intValue];
        }];
        
        RAC(self, isValidFirstName) = RACObserve(dreamerForm, isValidFirstName);
        RAC(self, isValidSecondName) = RACObserve(dreamerForm, isValidSecondName);
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