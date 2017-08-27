//
//  PMDreamForm.h
//  MyDreams
//
//  Created by user on 12.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMRestrictionLevel.h"
#import "PMImage.h"

@class PMDream;

@interface PMDreamForm : PMBaseModel
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *dreamDescription;
@property (strong, nonatomic) UIImage *photo;
@property (assign, nonatomic) PMDreamRestrictionLevel restrictionLevel;
@property (strong, nonatomic) NSNumber *isCameTrue;
@property (strong, nonatomic) NSNumber *cropRectX;
@property (strong, nonatomic) NSNumber *cropRectY;
@property (strong, nonatomic) NSNumber *cropRectWidth;
@property (strong, nonatomic) NSNumber *cropRectHeight;
@property (nonatomic, assign) BOOL isValidTitle;
@property (nonatomic, assign) BOOL isValidDescription;
@property (nonatomic, assign) BOOL isValidPhoto;

@property (strong, nonatomic) NSNumber *dreamIdx;
@property (strong, nonatomic) PMImage *photoURL;

- (void)validateTitle;
- (void)validateDescription;
- (void)validatePhoto;

- (instancetype)initWithDream:(PMDream *)dream;
@end
