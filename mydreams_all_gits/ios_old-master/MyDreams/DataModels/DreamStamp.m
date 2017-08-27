//
//  DreamStamps.m
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "DreamStamp.h"


@implementation DreamStamp
@end


@implementation DreamStampsResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.stamps.total": @"total",
                                                       @"body.stamps.items": @"items"
                                                       }];
}
@end
