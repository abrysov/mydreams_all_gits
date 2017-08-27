//
//  PMBaseModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface PMBaseModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, strong, readonly) NSNumber *idx;

+ (NSDictionary *)JSONKeyPathsByPropertyKey NS_REQUIRES_SUPER;

@end
