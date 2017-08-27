//
//  PMListOnlineImCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListOnlineImCommand.h"

@implementation PMListOnlineImCommand

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx
{
    self = [super init];
    if (self) {
        self.conversationIdx = conversationIdx;
    }
    return self;
}

- (NSString *)command
{
    return @"online_list";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(conversationIdx): @"conversation_id"};
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
