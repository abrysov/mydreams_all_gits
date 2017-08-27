//
//  DreamComments.m
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "DreamComment.h"


@implementation DreamComment
@end


@implementation DreamCommentsResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.comments.total": @"total",
                                                       @"body.comments.items": @"items"
                                                       }];
}
@end
