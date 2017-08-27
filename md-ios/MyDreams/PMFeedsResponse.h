//
//  PMFeedsResponse.h
//  MyDreams
//
//  Created by user on 08.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"
#import "PMPost.h"

@interface PMFeedsResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMPost *> *feeds;
@end
