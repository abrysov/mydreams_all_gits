//
//  PMListImCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseImCommand.h"

@class PMPage;

@interface PMListImCommand : PMBaseImCommand
@property (strong, nonatomic) NSNumber *conversationIdx;
@property (strong, nonatomic) NSNumber *sinceId;
@property (strong, nonatomic) NSNumber *count;

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx page:(PMPage *)page;

@end
