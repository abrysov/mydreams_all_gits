//
//  Dream.m
//  MyDreams
//
//  Created by Игорь on 13.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "Dream.h"

@implementation Dream

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"description": @"description_",
                                                       }];
}

+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"isliked"] ||
        [propertyName isEqualToString:@"isdone"]) {
        return YES;
    }
    return NO;
}

@end


@implementation DreamOwner
@end


@implementation DreamListResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.dreams.total": @"total",
                                                       @"body.dreams.items": @"dreams"
                                                       }];
}
@end


@implementation DreamResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.dream": @"dream"
                                                       }];
}
@end