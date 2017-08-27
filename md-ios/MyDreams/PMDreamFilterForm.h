//
//  PMDreamFilterForm.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"
#import "PMDreamerGender.h"

@interface PMDreamFilterForm : PMBaseModel
@property (strong, nonatomic) NSString *search;
@property (assign, nonatomic) PMDreamerGender gender;
@property (strong, nonatomic) NSNumber *isFulfilled;
@property (strong, nonatomic) NSNumber *isNew;
@property (strong, nonatomic) NSNumber *isHot;
@property (strong, nonatomic) NSNumber *isLiked;
@end
