//
//  PMLocalityListResponse.h
//  MyDreams
//
//  Created by user on 04.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"

@interface PMLocalitiesResponse : PMBaseResponse
@property (strong, nonatomic, readonly) NSArray *localities;
@end
