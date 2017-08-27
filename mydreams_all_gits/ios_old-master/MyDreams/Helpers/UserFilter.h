//
//  UserFilter.h
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserFilter : NSObject
@property (assign, nonatomic) NSInteger country;
@property (retain, nonatomic) NSString *countryName;
@property (assign, nonatomic) NSInteger city;
@property (retain, nonatomic) NSString *cityName;
@property (assign, nonatomic) BOOL popular;
@property (assign, nonatomic) BOOL isnew;
@property (assign, nonatomic) BOOL online;
@property (assign, nonatomic) BOOL vip;
@property (retain, nonatomic) NSString *sex;
@property (retain, nonatomic) NSString *age;
@end
