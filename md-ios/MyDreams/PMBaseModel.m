//
//  PMBaseModel.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMBaseModel ()
@property (nonatomic, strong) NSNumber *idx;
@end

@implementation PMBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{PMSelectorString(idx): @"id"};
}

@end
