//
//  PMPostForm.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMRestrictionLevel.h"

@class PMPost;
@class PMPostPhoto;

@interface PMPostForm : PMBaseModel
@property (assign, nonatomic) PMDreamRestrictionLevel restrictionLevel;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray <NSNumber *> *postPhotosIdxs;

@property (nonatomic, strong) NSArray <PMPostPhoto *> *postPhotos;
@property (strong, nonatomic) NSNumber *postIdx;
@property (nonatomic, assign) BOOL isValidDescription;
- (instancetype)initWithPost:(PMPost *)post;
@end
