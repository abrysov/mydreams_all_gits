//
//  PMPost.h
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMRestrictionLevel.h"
#import "PMdreamer.h"

@class PMPostPhoto;

@interface PMPost : PMBaseModel
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray<PMPostPhoto *> *photos;
@property (nonatomic, assign) NSUInteger likesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, assign) PMDreamRestrictionLevel restrictionLevel;
@property (nonatomic, strong) PMDreamer *dreamer;
@property (nonatomic, assign) BOOL likedByMe;
@property (nonatomic, strong) NSDate *createdAt;
@end
