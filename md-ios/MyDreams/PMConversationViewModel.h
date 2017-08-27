//
//  PMConversationViewModel.h
//  MyDreams
//
//  Created by Alexey Yakunin on 29/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMConversationViewModel <NSObject>

@property (strong, nonatomic, readonly) NSString* name;
@property (strong, nonatomic, readonly) NSString* lastMessageText;
@property (strong, nonatomic, readonly) NSString* numberOfMessages;
@property (strong, nonatomic, readonly) NSString* numberOfNewMessages;
@property (strong, nonatomic, readonly) UIColor* color;
@property (strong, nonatomic, readonly) NSString* dateString;
@property (assign, nonatomic, readonly) BOOL isVip;
@property (assign, nonatomic, readonly) BOOL isOnline;
@property (strong, nonatomic, readonly) RACSignal *avatarSignal;

@end
