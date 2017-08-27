//
//  PMListImCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListImCommand.h"
#import "PMPage.h"

@implementation PMListImCommand

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx page:(PMPage *)page
{
    self = [super init];
    if (self) {
        self.conversationIdx = conversationIdx;
        self.sinceId = page.from;
        self.count = page.per;
    }
    return self;
}

- (NSString *)command
{
    return @"list";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(conversationIdx): @"conversation_id",
                              PMSelectorString(sinceId): @"since_id",
                              PMSelectorString(count): @"count"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
