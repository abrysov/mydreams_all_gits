//
//  Post.m
//  MyDreams
//
//  Created by Игорь on 07.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "Post.h"

@implementation Post

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"description_",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"isliked"]) {
        return YES;
    }
    return NO;
}

@end


@implementation PostListResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.posts.total": @"total",
                                                       @"body.posts.items": @"posts"
                                                       }];
}
@end


@implementation PostResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.post": @"post"
                                                       }];
}
@end
