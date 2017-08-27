//
//  PMListCommentsCommand.h
//  MyDreams
//
//  Created by Иван Ушаков on 20.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseCommentCommand.h"
#import "PMEntityType.h"

@class PMPage;

@interface PMListCommentsCommand : PMBaseCommentCommand
@property (assign, nonatomic) PMEntityType resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;
@property (strong, nonatomic) NSNumber *sinceId;
@property (strong, nonatomic) NSNumber *count;

- (instancetype)initWithResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx page:(PMPage *)page;

@end
