//
//  Dream.h
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "JSONModel.h"
#import "CommonResponseModel.h"
#import "User.h"

@interface DreamOwner : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *fullname;
@end

@protocol Dream
@end

@interface Dream : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString<Optional> *description_;
@property (retain, nonatomic) NSString<Optional> *imageUrl;
@property (retain, nonatomic) NSDate<Optional> *date;
@property (assign, nonatomic) NSNumber<Optional> *likes;
@property (assign, nonatomic) NSNumber<Optional> *comments;
@property (assign, nonatomic) NSNumber<Optional> *stamps;
@property (retain, nonatomic) BasicUser<Optional> *owner;
@property (assign, nonatomic) BOOL isliked;
@property (assign, nonatomic) BOOL isdone;
@end

@interface DreamListResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <Dream, Optional> *dreams;
@end

@interface DreamResponseModel : CommonResponseModel
@property Dream *dream;
@end