//
//  PMPostDetailContext.h
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@class PMPost;

@interface PMDetailedPostContext : PMBaseContext
@property (nonatomic, strong) PMPost *post;
@property (nonatomic, strong) RACSubject *postSubject;
+ (instancetype)contextWithPost:(PMPost *)post subject:(RACSubject *)subject;
@end
