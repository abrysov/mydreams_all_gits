//
//  PMUnsubscribeCommentsCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 21.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseCommentCommand.h"
#import "PMEntityType.h"

@interface PMUnsubscribeCommentsCommand : PMBaseCommentCommand
@property (assign, nonatomic) PMEntityType resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
@end
