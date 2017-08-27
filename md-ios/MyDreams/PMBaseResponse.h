//
//  PMBaseResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Mantle/Mantle.h>
#import "PMResponseMeta.h"

@interface PMBaseResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) PMResponseMeta *meta;
@property (nonatomic, strong, readonly) NSDate *retrievedAt;
@property (nonatomic, assign, readonly) BOOL isFromOfflineCache;

+ (NSDictionary *)JSONKeyPathsByPropertyKey NS_REQUIRES_SUPER;

@end
