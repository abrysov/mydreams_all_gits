//
//  DreamLikes.m
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "DreamLike.h"


@implementation DreamLike
@end


@implementation DreamLikesResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.likes.total": @"total",
                                                       @"body.likes.items": @"items"
                                                       }];
}
@end