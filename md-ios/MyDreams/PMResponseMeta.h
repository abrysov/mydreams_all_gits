//
//  PMResponseMeta.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PMResponseMeta : MTLModel <MTLJSONSerializing>
@property (strong, readonly, nonatomic) NSString *status;
@property (strong, readonly, nonatomic) NSString *message;
@property (strong, readonly, nonatomic) NSDictionary *errors;
@property (assign, readonly, nonatomic) NSUInteger code;
@property (assign, readonly, nonatomic) BOOL isBlocked;
@property (assign, readonly, nonatomic) BOOL isDeleted;
@end
