//
//  PMPostResponse.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"

@class PMPost;

@interface PMPostResponse : PMBaseResponse
@property (nonatomic, strong, readonly) PMPost *post;
@end
