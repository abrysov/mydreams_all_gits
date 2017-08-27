//
//  EventFeed.m
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "EventFeed.h"

@implementation EventFeedItem
+ (BOOL)propertyIsOptional:(NSString*)propertyName {
    if ([propertyName isEqualToString:@"dream"]) {
        return YES;
    }
    return NO;
}
@end

@implementation EventFeedResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.events.total": @"total",
                                                       @"body.events.items": @"events"
                                                       }];
}
@end
