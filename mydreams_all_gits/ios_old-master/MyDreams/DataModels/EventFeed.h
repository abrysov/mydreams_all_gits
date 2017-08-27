//
//  EventFeed.h
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "JSONModel.h"
#import "CommonResponseModel.h"
#import "User.h"
#import "Dream.h"
#import "Flybook.h"

@protocol EventFeedItem
@end

@interface EventFeedItem : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) BasicUser<Optional> *user;
@property (retain, nonatomic) NSDate<Optional> *date;
@property (retain, nonatomic) NSString<Optional> *text;
@property (assign, nonatomic) Dream *dream;
//@property (retain, nonatomic) NSArray<FlybookPhoto, Optional> *photos;
@property (retain, nonatomic) FlybookPhoto<Optional> *photos;
@end

@interface EventFeedResponseModel : CommonResponseModel
@property NSInteger total;
@property NSArray <EventFeedItem, Optional> *events;
@end