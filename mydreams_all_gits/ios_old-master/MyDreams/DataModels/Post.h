//
//  Post.h
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSONModel.h"
#import "CommonResponseModel.h"
#import "User.h"

@protocol Post
@end

@interface Post : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString<Optional> *description_;
@property (retain, nonatomic) NSString<Optional> *imageUrl;
@property (retain, nonatomic) NSDate<Optional> *date;
@property (assign, nonatomic) NSNumber<Optional> *likes;
@property (assign, nonatomic) NSNumber<Optional> *comments;
@property (retain, nonatomic) BasicUser<Optional> *owner;
@property (assign, nonatomic) BOOL isliked;
@end

@interface PostListResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <Post, Optional> *posts;
@end

@interface PostResponseModel : CommonResponseModel
@property Post *post;
@end
