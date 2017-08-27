//
//  DreamComment.h
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseModel.h"
#import "User.h"


@protocol DreamComment
@end


@interface DreamComment : JSONModel
@property (assign, nonatomic) NSNumber<Optional> *id;
@property (retain, nonatomic) BasicUser *user;
@property (retain, nonatomic) NSDate *date;
@property (retain, nonatomic) NSString *text;
@property (assign, nonatomic) BOOL isliked;
@end


@interface DreamCommentsResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <DreamComment, Optional> *items;
@end
