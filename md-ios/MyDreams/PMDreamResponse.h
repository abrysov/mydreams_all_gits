//
//  PMDreamResponse.h
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMDream.h"

@interface PMDreamResponse : PMBaseResponse
@property (strong, readonly, nonatomic) PMDream *dream;
@end
