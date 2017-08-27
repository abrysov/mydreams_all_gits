//
//  PMTopDream.h
//  MyDreams
//
//  Created by user on 24.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@class PMImage;

@interface PMTopDream : PMBaseModel
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *dreamDescription;
@property (nonatomic, strong) PMImage *image;
@property (nonatomic, assign) NSUInteger likesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, assign) BOOL likedByMe;
@end
