//
//  PMSendImCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseImCommand.h"

@interface PMSendImCommand : PMBaseImCommand
@property (strong, nonatomic) NSNumber *conversationIdx;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSArray<NSNumber *> *attachments;

- (instancetype)initWithConversationIdx:(NSNumber *)conversationIdx message:(NSString *)message attachments:(NSArray<NSNumber *> *)attachments;

@end
