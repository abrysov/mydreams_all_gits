//
//  PMFeedCommentsResponse.h
//  MyDreams
//
//  Created by user on 05.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMExtendedPost;

@interface PMFeedCommentsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMExtendedPost *> *comments;
@end
