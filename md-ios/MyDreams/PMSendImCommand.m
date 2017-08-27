//
//  PMSendImCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSendImCommand.h"

@implementation PMSendImCommand

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx message:(NSString *)message attachments:(NSArray<NSNumber *> *)attachments
{
    self = [super init];
    if (self) {
        self.conversationIdx = conversationIdx;
        self.message = message;
        self.attachments = attachments;
    }
    
    return self;
}

- (NSString *)command
{
    return @"send";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(conversationIdx): @"conversation_id",
                              PMSelectorString(message): @"message",
                              PMSelectorString(attachments): @"attachments"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
