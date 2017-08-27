//
//  DreamLike.h
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseModel.h"
#import "User.h"


@protocol DreamLike
@end

@interface DreamLike : JSONModel
@property (retain, nonatomic) BasicUser *user;
@property (retain, nonatomic) NSDate *date;
@end


@interface DreamLikesResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <DreamLike, Optional> *items;
@end
