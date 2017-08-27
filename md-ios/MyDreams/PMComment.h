//
//  PMComment.h
//  MyDreams
//
//  Created by Иван Ушаков on 27.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMEntityType.h"
#import "PMDreamerGender.h"

@class PMReaction;
@class PMDreamer;

@interface PMComment : PMBaseModel
@property (assign, nonatomic) PMEntityType resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;
@property (strong, nonatomic) NSString *body;
@property (strong, nonatomic) NSString *dreamerFirstName;
@property (strong, nonatomic) NSString *dreamerLastName;
@property (strong, nonatomic) NSNumber *dreamerAge;
@property (strong, nonatomic) NSString *dreamerAvatar;
@property (assign, nonatomic) PMDreamerGender dreamerGender;
@property (strong, nonatomic) NSNumber *dreamerIdx;
@property (strong, nonatomic) NSArray<PMReaction *> *reactions;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) PMDreamer *dreamer;
@end
