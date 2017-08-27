//
//  PMCommentsResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 03.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketResponse.h"
#import "PMEntityType.h"

@class PMComment;

@interface PMCommentsResponse : PMBaseSocketResponse
@property (assign, nonatomic) PMEntityType resourceType;
@property (strong, nonatomic) NSNumber *resourceIdx;
@property (strong, nonatomic) NSNumber *sinceId;
@property (strong, nonatomic) NSArray<PMComment *> *comments;
@end
