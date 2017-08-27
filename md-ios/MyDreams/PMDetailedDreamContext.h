//
//  PMDreamDetailContext.h
//  MyDreams
//
//  Created by user on 26.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@class PMDream;

@interface PMDetailedDreamContext : PMBaseContext
@property (nonatomic, strong) PMDream *dream;
@property (nonatomic, strong) RACSubject *dreamSubject;
+ (instancetype)contextWithDream:(PMDream *)dream subject:(RACSubject *)subject;
@end
