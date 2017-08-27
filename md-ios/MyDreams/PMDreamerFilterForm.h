//
//  PMDreamerFilterForm.h
//  MyDreams
//
//  Created by user on 29.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMDreamerGender.h"

@interface PMDreamerFilterForm : PMBaseModel
@property (strong, nonatomic) NSString *search;
@property (strong, nonatomic) NSNumber *ageTo;
@property (strong, nonatomic) NSNumber *ageFrom;
@property (assign, nonatomic) PMDreamerGender gender;
@property (strong, nonatomic) NSNumber *isOnline;
@property (strong, nonatomic) NSNumber *isNew;
@property (strong, nonatomic) NSNumber *isTop;
@property (strong, nonatomic) NSNumber *isVip;
@property (strong, nonatomic) NSNumber *countryId;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSNumber *cityId;
@property (strong, nonatomic) NSString *city;

@end
