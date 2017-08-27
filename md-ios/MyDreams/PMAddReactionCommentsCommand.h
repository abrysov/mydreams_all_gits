//
//  PMAddReactionCommentsCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseCommentCommand.h"

@interface PMAddReactionCommentsCommand : PMBaseCommentCommand
@property (strong, nonatomic) NSNumber *commentIdx;
@property (strong, nonatomic) NSString *body;

- (instancetype)initWithCommentIdx:(NSNumber *)commentIdx body:(NSString *)body;
@end
