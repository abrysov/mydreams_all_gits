//
//  DreamStamp.h
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseModel.h"
#import "User.h"


@protocol DreamStamp
@end


@interface DreamStamp : JSONModel
@property (retain, nonatomic) BasicUser *user;
@property (retain, nonatomic) NSDate *date;
@end


@interface DreamStampsResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <DreamStamp, Optional> *items;
@end
