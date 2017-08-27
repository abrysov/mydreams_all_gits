//
//  User.m
//  MyDreams
//
//  Created by Игорь on 19.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "User.h"


@implementation BasicUser
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"subscribed"]
        || [propertyName isEqualToString:@"friend"]
        || [propertyName isEqualToString:@"friendshipRequestSended"]) {
        return YES;
    }
    return NO;
}

@end


@implementation BasicUsersResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.users.total": @"total",
                                                       @"body.users.items": @"items"
                                                       }];
}
@end