//
//  PMBaseSocketResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 03.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface PMBaseSocketResponse : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSDate *retrievedAt;
@property (nonatomic, assign, readonly) BOOL isFromOfflineCache;

+ (NSDictionary *)JSONKeyPathsByPropertyKey NS_REQUIRES_SUPER;
@end
