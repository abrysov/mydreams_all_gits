//
//  PMPostComment.h
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPost.h"

@class PMComment;
@class PMLike;

@interface PMExtendedPost : PMPost
@property (strong, nonatomic) NSArray <PMComment *> *lastComments;
@property (strong, nonatomic) NSArray <PMLike *> *lastLikes;
@end
