//
//  NSValueTransformer+PM.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Mantle/MTLValueTransformer.h>
#import "NSValueTransformer+PM.h"

@implementation NSValueTransformer (PM)

+ (NSDateFormatter *)createdAtAndupdatedAtDateFormatter
{
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    });
    
    return dateFormatter;
}

+ (NSValueTransformer *)createdAtAndupdatedAtTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.createdAtAndupdatedAtDateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.createdAtAndupdatedAtDateFormatter stringFromDate:date];
    }];
}

@end
