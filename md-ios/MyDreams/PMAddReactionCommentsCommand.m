//
//  PMAddReactionCommentsCommand.m
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddReactionCommentsCommand.h"

@implementation PMAddReactionCommentsCommand

- (instancetype)initWithCommentIdx:(NSNumber *)commentIdx body:(NSString *)body
{
    self = [super init];
    if (self) {
        self.commentIdx = commentIdx;
        self.body = body;
    }
    
    return self;
}

- (NSString *)command
{
    return @"add_reaction";
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{PMSelectorString(commentIdx): @"comment_id",
                              PMSelectorString(body): @"body"
                              };
    return [[super JSONKeyPathsByPropertyKey] mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end
