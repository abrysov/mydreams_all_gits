//
//  PMBaseSocketMessage.h
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mantle/Mantle.h>

@interface PMBaseSocketCommand : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSString *command;
@property (strong, nonatomic) NSString *idx;

+ (NSDictionary *)JSONKeyPathsByPropertyKey NS_REQUIRES_SUPER;

@end
