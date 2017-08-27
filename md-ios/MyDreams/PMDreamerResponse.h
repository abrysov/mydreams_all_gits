//
//  PMMeResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMDreamer.h"

@interface PMDreamerResponse : PMBaseResponse
@property (strong, readonly, nonatomic) PMDreamer *dreamer;
@end
