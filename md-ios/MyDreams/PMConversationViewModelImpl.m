//
//  PMConversationViewModelImpl.m
//  MyDreams
//
//  Created by Alexey Yakunin on 01/08/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMConversationViewModelImpl.h"

@interface PMConversationViewModelImpl ()
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* lastMessageText;
@property (strong, nonatomic) NSString* numberOfMessages;
@property (strong, nonatomic) NSString* numberOfNewMessages;
@property (strong, nonatomic) UIColor* color;
@property (strong, nonatomic) NSString* dateString;
@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) BOOL isOnline;
@property (strong, nonatomic) RACSignal *avatarSignal;
@end

@implementation PMConversationViewModelImpl

@end
