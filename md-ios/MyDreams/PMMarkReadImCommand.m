//
//  PMMarkReadImCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMMarkReadImCommand.h"

@implementation PMMarkReadImCommand

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx messageIdx:(NSNumber *)messageIdx
{
    self = [super init];
    if (self) {
        self.conversationIdx = conversationIdx;
        self.messageIdx = messageIdx;
    }
    return self;
}

- (NSString *)command
{
    return @"mark_read";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(conversationIdx): @"conversation_id",
                              PMSelectorString(messageIdx): @"message_id"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
