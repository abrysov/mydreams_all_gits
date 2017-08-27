//
//  PMMenuViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMMenuViewModel <NSObject>
@property (strong, readonly, nonatomic) NSString *fullName;
@property (strong, readonly, nonatomic) NSString *coinsCount;
@property (strong, readonly, nonatomic) NSString *messagesCount;
@property (strong, readonly, nonatomic) NSString *notificationsCount;
@property (strong, readonly, nonatomic) UIImage *avatar;
@end
