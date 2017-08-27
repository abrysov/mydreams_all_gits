//
//  PMSocketResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketCommand.h"
#import <Mantle/Mantle.h>

@interface PMSocketResponse  : MTLModel <MTLJSONSerializing>
@property (strong, nonatomic, readonly) NSString *type;
@property (strong, nonatomic, readonly) NSString *command;
@property (strong, nonatomic, readonly) NSString *replyTo;
@property (strong, nonatomic, readonly) id payload;
@end
