//
//  PMPostCommentsCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseCommentCommand.h"
#import "PMEntityType.h"

@interface PMPostCommentsCommand : PMBaseCommentCommand
@property (assign, nonatomic) PMEntityType resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;
@property (strong, nonatomic) NSString *body;

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx body:(NSString *)body;
@end
