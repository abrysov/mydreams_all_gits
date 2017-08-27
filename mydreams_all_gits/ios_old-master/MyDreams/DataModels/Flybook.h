//
//  Flybook.h
//  MyDreams
//
//  Created by Игорь on 05.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "JSONModel.h"
#import "CommonResponseModel.h"

@protocol Flybook
@end

@protocol FlybookPhoto
@end

@interface Flybook : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString<Optional> *name;
@property (retain, nonatomic) NSString<Optional> *surname;
@property (retain, nonatomic) NSString<Optional> *email;
@property (retain, nonatomic) NSString<Optional> *phone;
@property (assign, nonatomic) NSInteger sex;
@property (retain, nonatomic) NSString<Optional> *birthdate;
@property (retain, nonatomic) NSString<Optional> *location;
@property (assign, nonatomic) NSInteger locationId;
@property (retain, nonatomic) NSString<Optional> *avatarUrl;
@property (retain, nonatomic) NSString<Optional> *quote;
@property (assign, nonatomic) NSNumber<Optional> *friends;
@property (assign, nonatomic) NSNumber<Optional> *subscribers;
@property (assign, nonatomic) NSNumber<Optional> *launches;
@property (assign, nonatomic) NSNumber<Optional> *dreams;
@property (assign, nonatomic) NSNumber<Optional> *dreamsComplete;
@property (assign, nonatomic) NSNumber<Optional> *posts;
@property (assign, nonatomic) bool isVip;
@property (assign, nonatomic) NSInteger proposed;
@property (retain, nonatomic) NSArray<FlybookPhoto, Optional> *photos;
@property (assign, nonatomic) bool friendshipRequestSended;
@property (assign, nonatomic) bool friend;
@property (assign, nonatomic) bool subscribed;
@end

@interface FlybookPhoto : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *url;
@property (assign, nonatomic) NSString *thumbUrl;
@end

@interface FlybookResponseModel : CommonResponseModel
@property Flybook <Optional> *flybook;
@end