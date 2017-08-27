//
//  User.h
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "JSONModel.h"
#import "CommonResponseModel.h"


@protocol BasicUser
@end


@interface BasicUser : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString<Optional> *fullname;
@property (retain, nonatomic) NSString<Optional> *avatarUrl;
@property (retain, nonatomic) NSString<Optional> *location;
@property (retain, nonatomic) NSString<Optional> *age;
@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) BOOL friend;
@property (assign, nonatomic) BOOL subscribed;
@property (assign, nonatomic) BOOL friendshipRequestSended;
@end


@interface BasicUsersResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <BasicUser, Optional> *items;
@end
