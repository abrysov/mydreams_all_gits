//
//  PMPaginationResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Mantle/Mantle.h>
@class PMPaginationResponseMeta;

@interface PMPaginationResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) PMPaginationResponseMeta *meta;
@property (nonatomic, strong, readonly) NSDate *retrievedAt;
@property (nonatomic, assign, readonly) BOOL isFromOfflineCache;

+ (NSDictionary *)JSONKeyPathsByPropertyKey NS_REQUIRES_SUPER;

@end
