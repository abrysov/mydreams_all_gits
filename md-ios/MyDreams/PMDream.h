//
//  PMDream.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMRestrictionLevel.h"
#import "PMCertificateType.h"

@class PMImage;
@class PMDreamer;

@interface PMDream : PMBaseModel
@property (nonatomic, assign) PMDreamCertificateType certificateType;
@property (nonatomic, strong, readonly) NSString *certificateTypeString;
@property (nonatomic, assign) PMDreamRestrictionLevel restrictionLevel;
@property (nonatomic, assign) BOOL fulfilled;
@property (nonatomic, assign) BOOL likedByMe;
@property (nonatomic, assign) NSUInteger likesCount;
@property (nonatomic, assign) NSUInteger commentsCount;
@property (nonatomic, assign) NSUInteger launchesCount;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *details;
@property (nonatomic, strong) PMImage *image;
@property (nonatomic, strong) PMDreamer *dreamer;
@end
