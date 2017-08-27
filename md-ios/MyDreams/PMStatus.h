//
//  PMStatus.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@interface PMStatus : PMBaseModel
@property (assign, nonatomic, readonly) NSUInteger coinsCount;
@property (assign, nonatomic, readonly) NSUInteger messagesCount;
@property (assign, nonatomic, readonly) NSUInteger notificationsCount;
@property (assign, nonatomic, readonly) NSUInteger friendRequestsCount;
@end
