//
//  Flybook.m
//  MyDreams
//
//  Created by Игорь on 05.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "Flybook.h"

@implementation Flybook
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"subscribed"]
        || [propertyName isEqualToString:@"friend"]
        || [propertyName isEqualToString:@"friendshipRequestSended"]) {
        return YES;
    }
    return NO;
}
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"birthday": @"birthdate",
                                                       }];
}
@end

@implementation FlybookPhoto
@end

@implementation FlybookResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.profile": @"flybook",
                                                       }];
}
@end