//
//  PMEntityType.h
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PMEntityType) {
    PMEntityTypeUnknown,
    PMEntityTypeDream,
    PMEntityTypeTopDream,
    PMEntityTypePhoto,
    PMEntityTypePost
};

@interface PMEntityTypeConverter : NSObject

+ (NSValueTransformer *)transformer;
+ (NSString *)entityTypeToString:(PMEntityType)entityType;
+ (PMEntityType)stringToEntityType:(NSString *)string;

@end
